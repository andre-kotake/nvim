--- @type LazySpec[]
return {
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    init = function()
      local notify = require("notify")
      vim.notify = notify
    end,
    opts = {
      timeout = 3000,
      render = "wrapped-compact",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      handlers = {
        gitsigns = true, -- gitsigns integration (display hunks)
        ale = true, -- lsp integration (display errors/warnings)
        search = false, -- hlslens integration (display search result)
      },
      hide_if_all_visible = true,
      excluded_filetypes = {
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "alpha",
      },
    },
  },
  {
    "zeioth/highlight-undo.nvim",
    event = "FileStart",
    opts = {
      duration = 150,
      redo = { hlgroup = "IncSearch" },
    },
  },
}
