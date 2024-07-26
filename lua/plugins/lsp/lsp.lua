local _border = { border = "single" }
-- vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
-- vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#8be9fd]])
-- vim.cmd([[autocmd! ColorScheme * highlight link FloatBorder DiagnosticInfo]])

return {
  {
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
      --- @type vim.diagnostic.Opts
      diagnostics = {
        update_in_insert = true,
        -- virtual_text = false,

        --- @type vim.diagnostic.Opts.Float
        float = {
          border = _border[0],
          style = "minimal",
          header = "",
          source = true,
        },
      },
      document_highlight = {
        enabled = true,
      },

      servers = {
        lua_ls = {},
        bashls = { filetypes = { "sh", "bash" } },
        yamlls = {},
      },
    },
    init = function()
      -- TODO: Validar se Noice
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, _border)
      -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, _border)
    end,
  },
}
