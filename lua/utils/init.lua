local LazyUtil = require("lazy.core.util")

--- @class k_lazy.utils: LazyUtilCore
--- @field icons k_lazy.utils.icons
--- @field mason k_lazy.utils.mason
local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("utils." .. k)
    return t[k]
  end,
})

--- Get the options of a plugin managed by lazy.
--- @param plugin string The plugin to get options from
--- @return table opts # The plugin options, or empty table if no plugin.
function M.get_plugin_opts(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  local lazy_plugin_avail, lazy_plugin = pcall(require, "lazy.core.plugin")

  local opts = {}

  if lazy_config_avail and lazy_plugin_avail then
    local spec = lazy_config.spec.plugins[plugin]
    if spec then
      opts = lazy_plugin.values(spec, "opts")
    end
  end

  return opts
end

--- Add syntax matching rules for highlighting URLs/URIs.
function M.set_url_effect()
  --- regex used for matching a valid URL/URI string
  local url_matcher = "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)"
    .. "%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)"
    .. "[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|"
    .. "[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)"
    .. "|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*"
    .. "|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

  M.delete_url_effect()
  if vim.g.url_effect_enabled then
    vim.fn.matchadd("HighlightURL", url_matcher, 15)
  end
end

--- Delete the syntax matching rules for URLs/URIs if set.
function M.delete_url_effect()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then
      vim.fn.matchdelete(match.id)
    end
  end
end

--- Sets or creates a highlight group. If the highlight already exists,
--- then override only the specified highlights.
--- @param name string
--- @param highlight vim.api.keyset.highlight
function M.set_hl_group(name, highlight)
  local hl_info = vim.api.nvim_get_hl(0, { name = name }) or {}

  -- Merge new highlights with existing ones.
  local hl = M.merge({}, hl_info, highlight)

  vim.api.nvim_set_hl(0, name, hl)
end

return M
