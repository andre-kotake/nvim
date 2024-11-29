local manager = require("plugins.lsp.manager")

---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim", optional = true },
      { "hrsh7th/cmp-nvim-lsp", optional = true },
      {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-neo-tree/neo-tree.nvim",
        },
        config = true,
      },
    },
    event = "FileStart",
    opts = {
      servers = {
        -- File options have priority
        -- lua_ls = {
        --   on_attach = function(_, _)
        --     vim.keymap.set("n", "<leader>cf", function()
        --       vim.lsp.buf.format({ async = true })
        --     end, {
        --       desc = "Format",
        --       silent = true,
        --     })
        --   end,
        -- },
        bashls = {
          settings = {
            bashIde = {},
          },
          on_attach = function(_, bufnr) vim.cmd("setlocal keywordprg=:Man") end,
        },
      },
      default_config = {
        capabilities = manager:get_default_capabilities(),
        handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "single",
            silent = true,
          }),
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "single",
            silent = true,
          }),
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local _util = require("lspconfig.util")
      _util.default_config = vim.tbl_deep_extend("force", _util.default_config, opts.default_config)

      local servers = manager:get_servers(opts.servers)

      for server_name, server_opts in pairs(servers) do
        local ok, _ = pcall(function()
          manager:setup(lspconfig[server_name], server_opts)
          return true, server_name
        end)

        if not ok then vim.notify("lspconfig: Error setting up " .. server_name, vim.log.levels.INFO, {}) end
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "lukas-reineke/lsp-format.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    event = "FileStart",
    config = function()
      local null_ls = require("null-ls")
      -- local helpers = require("null-ls.helpers")
      local lsp_format = require("lsp-format")

      --- @diagnostic disable: need-check-nil
      -- local code_actions = null_ls.builtins.code_actions
      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting
      -- local hover = null_ls.builtins.hover
      -- local completion = null_ls.builtins.completion
      --- @diagnostic enable: need-check-nil

      null_ls.setup({
        border = "double",
        debug = false,
        log_level = "error",
        notify_format = "",
        sources = {
          -- lua
          formatting.stylua,
          diagnostics.selene,
          -- bash
          formatting.shellharden,
          formatting.shfmt.with({
            extra_args = { "-i", "2", "-ci", "-bn", "-s" },
          }),
        },
        update_in_insert = true,
        on_attach = function(client, bufnr)
          if manager.has_available_null_ls_formatters(bufnr) then lsp_format.on_attach(client, bufnr) end
        end,
      })
    end,
  },
}
