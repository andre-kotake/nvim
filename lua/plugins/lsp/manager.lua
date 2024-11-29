local M = {}
M.server_name = nil

--- @param server_name? string
function M:is_client_active(server_name)
  server_name = server_name or self.server_name
  return not vim.tbl_isempty(vim.lsp.get_clients({ name = server_name }))
end

-- check if the manager autocomd has already been configured since some servers can take a while to initialize
-- this helps guarding against a data-race condition where a server can get configured twice
-- which seems to occur only when attaching to single-files
--- @param server_name? string
function M:is_client_configured(server_name, ft)
  server_name = server_name or self.server_name
  ft = ft or vim.bo.filetype

  local active_autocmds =
    vim.api.nvim_get_autocmds({ event = "FileType", pattern = ft })
  for _, result in ipairs(active_autocmds) do
    if
      result.desc ~= nil and result.desc:match("server " .. server_name .. " ")
    then
      return true
    end
  end

  return false
end

--- @param server_name? string
function M:validate(server_name)
  vim.validate({ name = { server_name, "string" } })
  if M:is_client_active(server_name) or M:is_client_configured(server_name) then
    return false
  end

  return true
end

function M:get_servers(servers)
  -- Append all servers that have a separate config file.
  require("lazy.util").ls(
    vim.fn.stdpath("config") .. "/lua/plugins/lsp/servers/",
    function(_, name, type)
      if type == "file" then
        local file_name = name:gsub("%.%w+$", "")
        local server_opts = require("plugins.lsp.servers." .. file_name)

        if servers[file_name] ~= nil then
          server_opts =
            vim.tbl_deep_extend("force", servers[file_name], server_opts)
        end
        servers[file_name] = server_opts
      end
    end
  )

  return servers
end

function M:setup(server, server_opts)
  if not self:validate(server.name) then return end

  local opts = vim.tbl_deep_extend("force", server.config_def, server_opts, {
    on_attach = function(client, bufnr)
      -- Set mappings
      local mappings = {
        normal_mode = "n",
        insert_mode = "i",
        visual_mode = "v",
      }

      ---@alias Mappings {[string]: table}[]

      ---@type Mappings
      local buffer_mappings = {
        normal_mode = {
          ["<leader>cd"] = {
            function() vim.diagnostic.open_float() end,
            "Diagnostics (Line)",
          },
          ["<leader>cf"] = {
            function() M.format() end,
            "Format",
          },
          ["<leader>cl"] = {
            function() vim.print("Active LSP server: " .. client.name) end,
            "LSP Info",
          },
          ["gd"] = {
            "<cmd>lua vim.lsp.buf.definition()<CR>",
            "Go to [D]efinition",
          },
          ["gr"] = {
            "<cmd>lua vim.lsp.buf.references()<CR>",
            "Go to [R]eferences",
          },

          -- ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover" },
        },
        insert_mode = {
          ["<C-f>"] = {
            function() M.format() end,
            "Format",
          },
          ["<C-k>"] = {
            function() vim.diagnostic.open_float() end,
            "Diagnostics (Line)",
          },
        },
        visual_mode = {},
      }

      for mode_name, mode_char in pairs(mappings) do
        for key, remap in pairs(buffer_mappings[mode_name]) do
          vim.keymap.set(mode_char, key, remap[1], {
            buffer = bufnr,
            desc = remap[2],
            noremap = true,
            silent = true,
          })
        end
      end

      if type(server_opts.on_attach) == "function" then
        server_opts.on_attach(client, bufnr)
      end
    end,
    -- on_init = on_init,
    -- on_exit = on_exit,
    capabilities = self:get_default_capabilities(),
  })
  server.setup(opts)
  server.manager:try_add_wrapper(vim.api.nvim_get_current_buf())
end

function M:get_default_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem = {
    documentationFormat = {
      "markdown",
      "plaintext",
    },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
  }

  local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp_nvim_lsp then
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      cmp_nvim_lsp.default_capabilities()
    )
    return cmp_nvim_lsp.default_capabilities()
  end

  local has_lsp_file_operations, lsp_file_operations =
    pcall(require, "lsp-file-operations")
  if has_lsp_file_operations then
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      lsp_file_operations.default_capabilities()
    )
  end
  return capabilities
end

--- Wrapper for vim.lsp.buf.format() to provide defaults
--- @param opts? table|nil
function M.format(opts)
  opts = vim.tbl_deep_extend("force", {
    timeout_ms = 5000,
    async = false,
    filter = M.format_filter,
  }, opts or {})

  return vim.lsp.buf.format(opts)
end

--- Filter passed to vim.lsp.buf.format
--- Always selects null-ls if it's available and caches the value per buffer
--- @param client table client attached to a buffer
--- @return boolean if client matches
function M.format_filter(client)
  if M.has_available_null_ls_formatters() then
    return client.name == "null-ls"
  elseif client.supports_method("textDocument/formatting") then
    return true
  end

  return false
end

--- Cache table to store the available formatters for each filetype
local formatter_cache = {}

function M.has_available_null_ls_formatters(bufnr)
  local null_ls_ok, null_ls = pcall(require, "null-ls")
  if not null_ls_ok then return nil end

  local bo = bufnr and vim.bo[bufnr] or vim.bo
  local filetype = bo.filetype

  -- Check if the filetype is already cached
  if formatter_cache[filetype] ~= nil then return formatter_cache[filetype] end

  local null_ls_srcs = require("null-ls.sources").get_available(
    filetype,
    null_ls.methods.FORMATTING
  ) or {}

  -- Cache the result for the filetype
  formatter_cache[filetype] = #null_ls_srcs > 0
  return formatter_cache[filetype]
end

function M.setup_diagnostics()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    severity = { min = { vim.diagnostic.severity.INFO } },
    float = {
      severity_sort = true,
      border = "single",
      source = true,
    },
    virtual_text = {
      spacing = 2,
      source = true,
      -- prefix = "icons",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "󰌵",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
  })
end

return M
