---@type K_Global
_G.K_Global = {
  path = require("util.path"),
  is_android = vim.fn.isdirectory("/data") == 1,
}

_G.K_Utils = require("util")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
