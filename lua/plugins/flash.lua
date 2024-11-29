return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        autohide = true,
      },
    },
  },
  keys = function()
    require("which-key").add({
      "<leader>j",
      desc = "Jump",
      icon = function() return "⚡ " end,
    })
    return {
      {
        "<leader>j",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
      },
    }
  end,
}
