local view_max_width = math.floor(vim.o.columns * 0.90)

return {
  "rcarriga/nvim-notify",
  opts = {
    timeout = 4000,
    max_width = view_max_width,
    render = "wrapped-compact",
  },
}
