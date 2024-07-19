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
          border = "single",
        },
      },

      servers = {

        bashls = {
          filetypes = { "sh", "bash" },
        },

        yamlls = {},
      },
    },
  },
}
