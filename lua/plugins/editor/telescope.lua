return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>/", false },
    {
      "<leader>fC",
      function()
        require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
          cwd = require("lazy.core.config").options.root .. "/LazyVim",
        }))
      end,
      desc = "Find Plugin File",
    },
  },
  opts = {
    defaults = {
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_config = {
        prompt_position = "top",
        width = 0.90,
        height = 0.90,
      },
      winblend = 0,
    },
  },
}
