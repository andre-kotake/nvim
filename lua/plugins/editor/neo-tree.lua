local set_hl_group = K_Lazy.set_hl_group
local get_icon = K_Lazy.icons.get_icon

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      bind_to_cwd = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          -- "node_modules",
        },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          -- Hide the cursor and show only line highlight when neo-tree is focused.
          set_hl_group("Cursor", { blend = 100 })
        end,
      },
      {
        event = "neo_tree_buffer_leave",
        handler = function()
          -- Show the cursor when leaving neo-tree.
          set_hl_group("Cursor", { blend = 0 })
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
  },
}
