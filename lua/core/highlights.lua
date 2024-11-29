local setup_highlights = function()
  local hl
  hl = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = hl.fg, bg = "none" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(_) setup_highlights() end,
})

setup_highlights()
