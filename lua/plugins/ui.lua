--- @type LazySpec[]
return {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  { "MunifTanjim/nui.nvim" },
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
  { "nvim-tree/nvim-web-devicons" },
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
    config = function(_, opts) require("gitsigns").setup(opts) end,
  },
}
