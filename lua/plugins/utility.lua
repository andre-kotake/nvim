---@type LazySpec[]
return {
  { "nvim-lua/plenary.nvim" },
  {
    dir = vim.fn.expand("~/Repos/nvim-chezmoi"),
    lazy = false,
    opts = {
      debug = true,
    },
  },
  -- {
  --   "andre-kotake/nvim-chezmoi",
  --   event = "FileStart",
  --   opts = {
  --     -- Show extra debug messages.
  --     debug = false,
  --     -- chezmoi source path. Defaults to the result of `chezmoi source-path`
  --     -- Change this only if your dotfiles live in a different directory.
  --     source_path = nil,
  --     edit = {
  --       -- Automatically apply file on save. Can be one of: "auto", "confirm" or "never"
  --       apply_on_save = "confirm",
  --     },
  --     window = {
  --       -- Changes the layout for executed template window.
  --       execute_template = {
  --         relative = "editor",
  --         width = vim.o.columns,
  --         height = vim.o.lines,
  --         row = 0,
  --         col = 0,
  --         style = "minimal",
  --         border = "single",
  --       },
  --     },
  --   },
  -- },
  {
    "smjonas/inc-rename.nvim",
    event = "FileStart",
    opts = {
      -- input_buffer_type = "dressing",
    },
    config = function(_, opts)
      require("inc_rename").setup(opts)
      vim.keymap.set(
        "n",
        "<leader>cr",
        function() return ":IncRename " .. vim.fn.expand("<cword>") end,
        { expr = true, desc = "Rename current symbol" }
      )
    end,
  },
  {
    "doctorfree/cheatsheet.nvim",
    lazy = true,
    cmd = { "Cheatsheet" },
    keys = {
      {
        "<leader>?c",
        function() vim.cmd("Cheatsheet") end,
        desc = "Cheatsheet",
      },
    },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local ctactions = require("cheatsheet.telescope.actions")
      require("cheatsheet").setup({
        bundled_cheetsheets = {
          enabled = {
            "default",
            "lua",
            "markdown",
            "regex",
          },
          disabled = {
            "nerd-fonts",
          },
        },
        bundled_plugin_cheatsheets = {
          enabled = {
            -- "auto-session",
            -- "goto-preview",
            -- "octo.nvim",
            "telescope.nvim",
            -- "vim-easy-align",
            -- "vim-sandwich",
          },
          -- disabled = { "gitsigns" },
        },
        include_only_installed_plugins = true,
        telescope_mappings = {
          ["<CR>"] = ctactions.select_or_fill_commandline,
          ["<A-CR>"] = ctactions.select_or_execute,
          ["<C-Y>"] = ctactions.copy_cheat_value,
          ["<C-E>"] = ctactions.edit_user_cheatsheet,
        },
      })
    end,
  },
  {
    "echasnovski/mini.misc",
    version = false,
    lazy = false,
    event = "VeryLazy",
    opts = {
      make_global = {
        "put",
        "put_text",
      },
    },
    config = function(_, opts)
      local mini_misc = require("mini.misc")
      mini_misc.setup(opts)
      mini_misc.setup_restore_cursor()
      mini_misc.setup_auto_root()
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "FileStart",
    opts = {},
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function() end,
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 4
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    keys = {
      {
        "<leader>wp",
        function()
          local win_id = require("window-picker").pick_window()
          if win_id then vim.api.nvim_set_current_win(win_id) end
        end,
        desc = "Window Picker",
      },
    },
    opts = {
      hint = "floating-big-letter",
      filter_rules = {
        include_current_win = false,
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = {
            -- "neo-tree",
            "neo-tree-popup",
            "notify",
          },
          -- if the buffer type is one of following, the window will be ignored
          buftype = { "terminal", "quickfix" },
        },
      },
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function(_)
      require("colorizer").setup()
      -- execute colorizer as soon as possible
      vim.defer_fn(function() require("colorizer").attach_to_buffer(0) end, 0)
    end,
  },
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaWrite", "SudaRead" },
    event = "FileStart",
    keys = {
      {
        "<leader>W",
        "<cmd>SudaWrite<cr><esc>",
        desc = "Save File (sudo)",
      },
    },
    cond = function() return not require("core.utils.validations").is_termux() end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts_extend = { "library" },
    opts = function(_, opts)
      opts.library = {
        vim.fn.expand("$VIMRUNTIME/lua"),
        vim.fn.stdpath("config") .. "/lua",
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "lazy.nvim", words = { "Lazy" } },
      }
    end,
    specs = {
      { "Bilal2453/luvit-meta", lazy = true },
      { "hrsh7th/nvim-cmp", optional = true },
    },
  },
}
