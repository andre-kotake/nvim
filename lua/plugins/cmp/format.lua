local M = {}

local lspkind = require("lspkind")
local nvim_web_devicons = require("nvim-web-devicons")
local cmp_kinds = {
  Text = "  ",
  Method = "  ",
  Function = "  ",
  Constructor = "  ",
  Field = "  ",
  Variable = "  ",
  Class = "  ",
  Interface = "  ",
  Module = "  ",
  Property = "  ",
  Unit = "  ",
  Value = "  ",
  Enum = "  ",
  Keyword = "  ",
  Snippet = "  ",
  Color = "  ",
  File = "  ",
  Reference = "  ",
  Folder = "  ",
  EnumMember = "  ",
  Constant = "  ",
  Struct = "  ",
  Event = "  ",
  Operator = "  ",
  TypeParameter = "  ",
}

M.window = function()
  local bordered_win = require("cmp.config.window").bordered({
    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    border = "none",
  })
  local w = {
    completion = bordered_win,
    documentation = bordered_win,
  }

  if require("core.utils.validations").is_termux() then
    w.completion.border = "single"
    w.documentation.border = "single"
    w.completion.col_offset = -99999
  end

  return w
end

M.entries = {
  fields = {
    "abbr",
    "kind",
    "menu",
  },
  format = function(entry, item)
    -- Define menu shorthand for different completion sources.
    -- Set the menu "icon" to the shorthand for each completion source.
    item.menu = ({
      lazydev = "LDEV",
      nvim_lsp = "NLSP",
      nvim_lua = "NLUA",
      luasnip = "LSNP",
      buffer = "BUFF",
      path = "PATH",
      cmdline = "CLINE",
    })[entry.source.name]

    -- Set the fixed width of the completion menu to half the visibl
    -- columns if in command mode
    local fixed_width = vim.fn.mode() == "c" and math.floor(vim.o.columns * 0.5)

    -- Set 'fixed_width' to false if not provided.
    fixed_width = fixed_width or false

    -- Set the fixed completion window width .
    if fixed_width then vim.o.pumwidth = fixed_width end

    -- Get the width of the current window.
    local win_width = vim.api.nvim_win_get_width(0)

    -- Set the max content width based on either: 'fixed_width'
    -- or a percentage of the window width, in this case 20%.
    -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
    local max_content_width = fixed_width and fixed_width - 10
      or math.floor(win_width * 0.3)

    -- Get the completion entry text shown in the completion window.
    local content = item.abbr

    -- Truncate the completion entry text if it's longer than the
    -- max content width. We subtract 3 from the max content width
    -- to account for the "..." that will be appended to it.
    if #content > max_content_width then
      item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
    else
      item.abbr = content .. (" "):rep(max_content_width - #content)
    end

    if vim.tbl_contains({ "path" }, entry.source.name) then
      local icon, hl_group =
        nvim_web_devicons.get_icon(entry:get_completion_item().label)
      if icon then
        item.kind = icon
        item.kind_hl_group = hl_group
        return item
      end
    end

    item.kind = (cmp_kinds[item.kind] or "") .. item.kind

    return lspkind.cmp_format({
      mode = "symbol_text",
    })(entry, item)
  end,
}

return M
