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
    icons = { keys = { BS = "󰁮 " } },
  },
  config = function(_, opts)
    local which_key = require("which-key")
    which_key.setup(opts)
    which_key.add({
      {
        "<esc>",
        desc = "Dismiss notifications",
        callback = function()
          local ok, notify = pcall(require, "notify")
          if ok then notify.dismiss({
            silent = true,
            pending = false,
          }) end

          vim.cmd("noh")
        end,
      },
      {
        "<leader>b",
        group = "Buffers",
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
      { "<leader>f", group = "Find" },
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
