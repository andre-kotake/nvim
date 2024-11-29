local setup = function()
  local setup_highlights = function()
    local hl_float_border = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
    local hl_normal = vim.api.nvim_get_hl(0, { name = "NormalFloat" })

    vim.api.nvim_set_hl(0, "FloatBorder", { fg = hl_float_border.fg, bg = hl_normal.bg })
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = setup_highlights,
  })

  setup_highlights()
end

setup()
