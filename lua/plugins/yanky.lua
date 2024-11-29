---@type LazySpec
return {
  "gbprod/yanky.nvim",
  event = "VeryLazy",
  opts = {
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 100,
    },
  },
  config = function(_, opts)
    require("yanky").setup(opts)

    vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
    vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
    vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
    vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
    vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
    vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension("yank_history")
      vim.keymap.set({ "n", "x" }, "fy", telescope.extensions.yank_history.yank_history, {
        desc = "Yank History",
        noremap = true,
      })
    end
  end,
}
