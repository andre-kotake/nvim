--- @class k_lazy.utils.icons
local M = {}

--- Taken from NormalNvim: https://github.com/NormalNvim/NormalNvim
--- Get an icon from `lspkind` if it is available and return it.
--- @param kind string The kind of icon in `lspkind` to retrieve.
--- @return string icon.
function M.get_icon(kind, padding, no_fallback)
  if not vim.g.icons_enabled and no_fallback then
    return ""
  end
  local icon_pack = vim.g.icons_enabled and "nerd_icons" or "text_icons"
  if not M[icon_pack] then
    M.nerd_icons = require("utils.icons.nerd_font")
    M.text_icons = require("utils.icons.text")
  end
  local icon = M[icon_pack] and M[icon_pack][kind]
  return icon and icon .. string.rep(" ", padding or 0) or ""
end

return M
