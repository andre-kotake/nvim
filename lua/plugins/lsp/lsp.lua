local _border = { border = "single" }
-- vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
-- vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#8be9fd]])
-- vim.cmd([[autocmd! ColorScheme * highlight link FloatBorder DiagnosticInfo]])

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason-lspconfig.nvim", enabled = false, config = function() end },
    {
      "sontungexpt/better-diagnostic-virtual-text",
      enabled = false,
      opts = {
        inline = false,
      },
    },
  },

  opts = {
    ---@type vim.diagnostic.Opts
    diagnostics = {
      update_in_insert = true,
      virtual_text = true,

      float = {
        border = _border[0],
        style = "minimal",
        header = "",
        source = true,
      },
      document_highlight = {
        enabled = true,
      },
    },
    servers = {
      lua_ls = {},
      bashls = { filetypes = { "sh", "bash" } },
      jsonls = {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
          json = {
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        -- Have to add this for yamlls to understand that we support line folding
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas =
            vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            format = {
              enable = true,
            },
            validate = true,
            schemaStore = {
              -- Must disable built-in schemaStore support to use
              -- schemas from SchemaStore.nvim plugin
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
          },
        },
      },
    },
  },
  setup = {
    yamlls = function()
      -- Neovim < 0.10 does not have dynamic registration for formatting
      if vim.fn.has("nvim-0.10") == 0 then
        LazyVim.lsp.on_attach(function(client, _)
          client.server_capabilities.documentFormattingProvider = true
        end, "yamlls")
      end
    end,
  },
  init = function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, _border)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, _border)
  end,
}
