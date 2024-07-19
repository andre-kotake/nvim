return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      local get_icon = require("util").get_icon
      opts.close_if_last_window = true

      opts.filesystem = {
        bind_to_cwd = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            "node_modules",
          },
        },
        follow_current_file = {
          enable = true,
          leave_dirs_open = true,
        },
      }

      opts.add_blank_line_at_top = true

      opts.source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          {
            source = "filesystem",
            display_name = get_icon("FolderClosed", 1, true) .. "File",
          },
          {
            source = "buffers",
            display_name = get_icon("DefaultFile", 1, true) .. "Bufs",
          },
          {
            source = "git_status",
            display_name = get_icon("Git", 1, true) .. "Git",
          },
        },
      }
    end,
  },
}
