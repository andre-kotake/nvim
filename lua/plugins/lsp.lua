return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        update_in_insert = true,
        virtual_text = false,
      },
      servers = {
        lua_ls = {
          -- mason = false,
          -- settings = {
          --   Lua = {
          --     workspace = {
          --       checkThirdParty = false,
          --     },
          --     codeLens = {
          --       enable = true,
          --     },
          --     completion = {
          --       callSnippet = "Replace",
          --     },
          --     doc = {
          --       privateName = { "^_" },
          --     },
          --     hint = {
          --       enable = true,
          --       setType = false,
          --       paramType = true,
          --       paramName = "Disable",
          --       semicolon = "Disable",
          --       arrayIndex = "Disable",
          --     },
          --   },
          -- },
        },
        bashls = {
          filetypes = { "sh", "bash" },
        },
        taplo = {},
        yamlls = {},
      },
    },
  },
  {
    "sontungexpt/better-diagnostic-virtual-text",
    event = "LspAttach",
    opts = {
      ui = {
        above = true,
      },
      inline = false,
    },
  },
}
