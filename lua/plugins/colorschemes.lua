--- @type LazySpec[]
return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      italic_comment = false,
      overrides = function(colors)
        return {
          CmpItemAbbrDeprecated = { bg = "NONE", strikethrough = true, fg = "#808080" },
          CmpItemAbbrMatch = { bg = "NONE", fg = "#569CD6" },
          CmpItemAbbrMatchFuzzy = { link = "CmpIntemAbbrMatch" },
          CmpItemKindVariable = { bg = "NONE", fg = "#9CDCFE" },
          CmpItemKindInterface = { link = "CmpItemKindVariable" },
          CmpItemKindText = { link = "CmpItemKindVariable" },
          CmpItemKindFunction = { bg = "NONE", fg = "#C586C0" },
          CmpItemKindMethod = { link = "CmpItemKindFunction" },
          CmpItemKindKeyword = { bg = "NONE", fg = "#D4D4D4" },
          CmpItemKindProperty = { link = "CmpItemKindKeyword" },
          CmpItemKindUnit = { link = "CmpItemKindKeyword" },
        }
      end,
    },
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      style = "dark",
      -- Enable italic comment
      italic_comments = false,
      -- Underline `@markup.link.*` variants
      underline_links = true,
      -- Disable nvim-tree background color
      disable_nvimtree_bg = true,
    },
  },
  {
    "folke/tokyonight.nvim",
    -- event = "UiEnter",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = false },
        keywords = { italic = false },
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      on_highlights = function(hl, c)
        hl.CmpItemAbbrDeprecated = { bg = "NONE", strikethrough = true, fg = "#808080" }
        hl.CmpItemAbbrMatch = { bg = "NONE", fg = c.blue }
        hl.CmpItemAbbrMatchFuzzy = { link = "CmpIntemAbbrMatch" }
        hl.CmpItemKindVariable = { bg = "NONE", fg = c.cyan }
        hl.CmpItemKindInterface = { link = "CmpItemKindVariable" }
        hl.CmpItemKindText = { link = "CmpItemKindVariable" }
        hl.CmpItemKindFunction = { bg = "NONE", fg = c.magenta_bright }
        hl.CmpItemKindMethod = { link = "CmpItemKindFunction" }
        hl.CmpItemKindKeyword = { bg = "NONE", fg = "#D4D4D4" }
        hl.CmpItemKindProperty = { link = "CmpItemKindKeyword" }
        hl.CmpItemKindUnit = { link = "CmpItemKindKeyword" }
      end,
    },
    -- config = function(_, opts)
    -- require("tokyonight").setup(opts)
    -- vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'red' })
    -- vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'red' })
    -- end,

    -- colorscheme tokyonight-night
    -- colorscheme tokyonight-storm
    -- colorscheme tokyonight-day
    -- colorscheme tokyonight-moon
  },

  -- {
  --   "maxmx03/dracula.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = false,
  --     plugins = {
  --       ["nvim-treesitter"] = true,
  --       ["nvim-lspconfig"] = true,
  --       ["nvim-navic"] = true,
  --       ["nvim-cmp"] = true,
  --       ["indent-blankline.nvim"] = true,
  --       ["neo-tree.nvim"] = true,
  --       ["nvim-tree.lua"] = true,
  --       ["which-key.nvim"] = true,
  --       ["dashboard-nvim"] = true,
  --       ["gitsigns.nvim"] = true,
  --       ["neogit"] = true,
  --       ["todo-comments.nvim"] = true,
  --       ["lazy.nvim"] = true,
  --       ["telescope.nvim"] = true,
  --       ["noice.nvim"] = false,
  --       ["hop.nvim"] = true,
  --       ["mini.statusline"] = true,
  --       ["mini.tabline"] = true,
  --       ["mini.starter"] = true,
  --       ["mini.cursorword"] = true,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("dracula").setup(opts)
  --     vim.cmd.colorscheme("dracula")
  --   end,
  -- },
}
