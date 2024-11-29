local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_mapping = require("cmp.config.mapping")
local cmp_types = require("cmp.types.cmp")
local ConfirmBehavior = cmp_types.ConfirmBehavior
local SelectBehavior = cmp_types.SelectBehavior

local M = {}

M.mapping = cmp_mapping.preset.insert({
  -- Open completion
  ["<C-Space>"] = cmp_mapping(function()
    if not M.docs_toggle() then cmp.complete() end
  end, { "i", "c" }),
  -- Toggle docs
  -- Menu movement
  ["<Down>"] = cmp_mapping(
    cmp_mapping.select_next_item({ behavior = SelectBehavior.Select }),
    { "i" }
  ),
  ["<Up>"] = cmp_mapping(
    cmp_mapping.select_prev_item({ behavior = SelectBehavior.Select }),
    { "i" }
  ),
  -- Docs scrolling
  ["<C-b>"] = cmp_mapping.scroll_docs(-2),
  ["<C-f>"] = cmp_mapping.scroll_docs(2),
  -- Confirm completion
  ["<CR>"] = cmp.mapping({
    i = function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
      else
        fallback()
      end
    end,
    s = cmp.mapping.confirm({ select = true }),
    c = function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        })
      end
      fallback()
    end,
  }),
  -- ["<CR>"] = cmp_mapping(function(fallback)
  --   if _cmp.visible() then
  --     local confirm_opts = {
  --       select = false,
  --       ConfirmBehavior.Replace,
  --     }
  --
  --     local is_insert_mode = function()
  --       return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
  --     end
  --     if is_insert_mode() then -- prevent overwriting brackets
  --       confirm_opts.behavior = ConfirmBehavior.Insert
  --     end
  --
  --     if M.confirm(confirm_opts) then
  --       return -- success, exit early
  --     end
  --   end
  --   fallback() -- if not exited early, always fallback
  -- end, { "i", "c" }),
  ["<C-y>"] = cmp_mapping({
    i = cmp_mapping.confirm({
      behavior = ConfirmBehavior.Replace,
      select = false,
    }),
    c = function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
      else
        fallback()
      end
    end,
  }),
  -- Exit menu
  ["<C-e>"] = cmp_mapping(function(_) cmp.close() end, { "i", "c" }),
  ["<ESC>"] = cmp_mapping.abort(),

  -- LuaSnip mappings
  ["<Tab>"] = cmp_mapping(function(fallback)
    if cmp.visible() then
      if #cmp.get_entries() == 1 then
        M.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Replace,
        })
      else
        cmp.select_next_item()
      end
    elseif luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif M.jumpable(1) then
      luasnip.jump(1)
    elseif M.has_words_before() then
      cmp.complete()
      fallback()
    else
      fallback()
    end
  end, { "i", "s", "c" }),
  ["<S-Tab>"] = cmp_mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s", "c" }),
})

function M.docs_toggle()
  if cmp.visible() then
    if cmp.visible_docs() then
      cmp.close_docs()
      return true
    else
      cmp.open_docs()
      return true
    end
  end

  return false
end

function M.has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s")
      == nil
end

--- when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
--- @param dir number 1 for forward, -1 for backward; defaults to 1
--- @return boolean true if a jumpable luasnip field is found while inside a snippet
function M.jumpable(dir)
  if not luasnip then return false end

  local win_get_cursor = vim.api.nvim_win_get_cursor
  local get_current_buf = vim.api.nvim_get_current_buf

  --- sets the current buffer's luasnip to the one nearest the cursor
  --- @return boolean true if a node is found, false otherwise
  local function seek_luasnip_cursor_node()
    local node = luasnip.session.current_nodes[get_current_buf()]
    if not node then return false end

    local snippet = node.parent.snippet
    local exit_node = snippet.insert_nodes[0]

    local pos = win_get_cursor(0)
    pos[1] = pos[1] - 1

    -- exit early if we're past the exit node
    if exit_node then
      local exit_pos_end = exit_node.mark:pos_end()
      if
        (pos[1] > exit_pos_end[1])
        or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2])
      then
        snippet:remove_from_jumplist()
        luasnip.session.current_nodes[get_current_buf()] = nil

        return false
      end
    end

    node = snippet.inner_first:jump_into(1, true)
    while node ~= nil and node.next ~= nil and node ~= snippet do
      local n_next = node.next
      local next_pos = n_next and n_next.mark:pos_begin()
      local candidate = n_next ~= snippet
          and next_pos
          and (pos[1] < next_pos[1])
        or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

      -- Past unmarked exit node, exit early
      if n_next == nil or n_next == snippet.next then
        snippet:remove_from_jumplist()
        luasnip.session.current_nodes[get_current_buf()] = nil

        return false
      end

      if candidate then
        luasnip.session.current_nodes[get_current_buf()] = node
        return true
      end

      local ok
      ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
      if not ok then
        snippet:remove_from_jumplist()
        luasnip.session.current_nodes[get_current_buf()] = nil

        return false
      end
    end

    -- No candidate, but have an exit node
    if exit_node then
      -- to jump to the exit node, seek to snippet
      luasnip.session.current_nodes[get_current_buf()] = snippet
      return true
    end

    -- No exit node, exit from snippet
    snippet:remove_from_jumplist()
    luasnip.session.current_nodes[get_current_buf()] = nil
    return false
  end

  if dir == -1 then
    return luasnip.in_snippet() and luasnip.jumpable(-1)
  else
    return luasnip.in_snippet()
      and seek_luasnip_cursor_node()
      and luasnip.jumpable(1)
  end
end

-- This is a better implementation of `cmp.confirm`:
--  * check if the completion menu is visible without waiting for running sources
--  * create an undo point before confirming
-- This function is both faster and more reliable.
---@param opts? {select: boolean, behavior: cmp.ConfirmBehavior}
function M.confirm(opts)
  opts = vim.tbl_extend("force", {
    select = true,
    behavior = cmp.ConfirmBehavior.Insert,
  }, opts or {})
  -- Util.create_undo()
  if cmp.confirm(opts) then return true end
  return false
end

return M.mapping
