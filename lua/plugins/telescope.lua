return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>/", false },
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
            cwd = require("lazy.core.config").options.root,
          }))
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_config = {
          prompt_position = "top",
        },
        winblend = 0,
      },
    },
  },
}
