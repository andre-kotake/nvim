---@type K_Global
_G.K_Global = {
  path = require("util.path"),
  is_android = vim.fn.isdirectory("/data") == 1,
}

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
