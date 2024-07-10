---@class global.util.path
---@field config string

---@type global.util.path
local M = {
  config = os.getenv("HOME") .. "/.config/",
}

return M
