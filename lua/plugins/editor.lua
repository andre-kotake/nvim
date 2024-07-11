return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        bind_to_cwd = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            "node_modules",
          },
        },
      },
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          {
            source = "filesystem",
            display_name = "File",
            -- display_name = get_icon("FolderClosed", 1, true) .. "File",
          },
          {
            source = "buffers",
            display_name = "Bufs",
            -- display_name = get_icon("DefaultFile", 1, true) .. "Bufs",
          },
          {
            source = "git_status",
            display_name = "Git",
            -- display_name = get_icon("Git", 1, true) .. "Git",
          },
        },
      },
      enable_cursor_hijack = true,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
       -- add a keymap to browse plugin files
       -- stylua: ignore
       {
         "<leader>fP",
         function() require("telescope.builtin").find_files(
          require('telescope.themes').get_dropdown({
            cwd = require("lazy.core.config").options.root
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
