local M = {}

--- Get an icon from given its icon name.
--- if vim.g.fallback_icons_enabled = true, it will return a fallback icon
--- unless specified otherwise.
--- @param icon_name string Name of the icon to retrieve.
--- @param fallback_to_empty_string boolean|nil If this parameter is true, when `vim.g.fallback_icons_enabled = true` then `get_icon()` will return empty string.
--- @return string icon.
function M.get(icon_name, fallback_to_empty_string)
  -- guard clause
  if fallback_to_empty_string and vim.g.fallback_icons_enabled then
    return ""
  end

  -- get icon_pack
  local icon_pack = (vim.g.fallback_icons_enabled and "fallback_icons")
    or "icons"

  -- cache icon_pack into M
  if not M[icon_pack] then -- only if not cached already.
    if icon_pack == "icons" then
      M.icons = require("core.utils.icons.icons")
    elseif icon_pack == "fallback_icons" then
      M.fallback_icons = require("core.utils.icons.fallback_icons")
    end
  end

  -- return specified icon
  local icon = M[icon_pack] and M[icon_pack][icon_name]
  return icon
end

return M
