local M = {}

function M.remove_item(tbl, item)
  for i, v in ipairs(tbl) do
    if v == item then
      table.remove(tbl, i)
      return true -- Return true when the item is removed
    end
  end
  return false -- Return false if no matching item is found
end

return M
