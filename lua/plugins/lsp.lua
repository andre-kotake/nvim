local _border = { border = "single" }

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim", enabled = false, config = function() end },
      {
        "sontungexpt/better-diagnostic-virtual-text",
        opts = {
          inline = false,
        },
      },
    },
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        update_in_insert = true,
        virtual_text = false,

        float = {
          border = _border[0],
          source = true,
        },
      },

      servers = {
        bashls = { filetypes = { "sh", "bash" } },
        yamlls = {},
      },
    },
    init = function()
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, _border)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, _border)
    end,
  },
}
