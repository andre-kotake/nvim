local get_icon = require("util").get_icon

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
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.cmd("highlight! Cursor blend=100")
          end,
        },
        {
          event = "neo_tree_buffer_leave",
          handler = function()
            vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
          end,
        },
        {
          event = "after_render",
          handler = function(state)
            if state.current_position == "left" or state.current_position == "right" then
              vim.api.nvim_win_call(state.winid, function()
                local str = require("neo-tree.ui.selector").get()
                if str then
                  _G.__cached_neo_tree_selector = str
                end
              end)
            end
          end,
        },
      },
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
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
      },
      enable_cursor_hijack = true,
    },
  },
}
