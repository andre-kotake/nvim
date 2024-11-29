---@type LazySpec
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>??",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  opts = {
    preset = "modern",
    delay = 100,
    icons = {
      keys = { BS = "󰁮 " },
      mappings = not vim.g.enable_keymap_desc_icons,
    },
  },
  config = function(_, opts)
    local icons = require("core.utils.icons")
    local keymaps = require("core.keymaps")

    local which_key = require("which-key")
    which_key.setup(opts)
    which_key.add({
      {
        "<esc>",
        desc = "Dismiss notifications",
        callback = function()
          local ok, notify = pcall(require, "notify")
          if ok then
            notify.dismiss({
              silent = true,
              pending = false,
            })
          end
          vim.cmd("noh")
        end,
      },
      {
        "<leader>b",
        group = keymaps.get_desc("Buffer"),
        icon = function() return icons.get("Buffer", true) end,
        {
          {
            "<leader>bb",
            desc = "Select",
            callback = function() require("telescope.builtin").buffers() end,
            -- expand = function() return require("which-key.extras").expand.buf() end,
          },
        },
      },
      { "<leader>c", group = "Code" },
      {
        "<leader>f",
        group = keymaps.get_desc("Find"),
        icon = function() return icons.get("Find", true) end,
      },
      { "<leader>q", group = "Exit" },
      { "<leader>s", group = "Search" },
      {
        "<leader>o",
        group = "Options",
        icon = function() return " " end,
        {
          {
            "<leader>ow",
            desc = "Toggle Wrap",
            callback = function() vim.o.wrap = not vim.o.wrap end,
            -- expand = function() return require("which-key.extras").expand.buf() end,
          },
        },
      },
      { "<leader>w", group = "Window", proxy = "<c-w>" }, -- proxy to window mappings
    })
  end,
}
