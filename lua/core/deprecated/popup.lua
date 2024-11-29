local namespace = vim.api.nvim_create_namespace("search_highlight")
vim.api.nvim_set_hl(namespace, "SearchHighlight", { link = "Search" })

-- Function to add Search highlight for a given text in the current buffer
local function highlight_search_text(pattern, win, buf_nr)
  vim.api.nvim_buf_clear_namespace(buf_nr, namespace, 0, -1) -- Clears all highlights for the buffer

  if pattern == "" then return end

  vim.api.nvim_win_set_hl_ns(win, namespace)
  local line_count = vim.api.nvim_buf_line_count(buf_nr)

  -- Loop through each line in the buffer to search for the pattern
  for i = 0, line_count - 1 do
    local line = vim.api.nvim_buf_get_lines(buf_nr, i, i + 1, false)[1]
    local start_col, end_col = string.find(line, pattern)

    -- If pattern is found in the line, highlight the match
    while start_col do
      vim.api.nvim_buf_add_highlight(buf_nr, namespace, "SearchHighlight", i, start_col - 1, end_col or -1)
      -- Search for the next occurrence in the same line
      start_col, end_col = string.find(line, pattern, end_col + 1)
    end
  end
end

local function popup(word, buf, win)
  local Input = require("nui.input")
  local event = require("nui.utils.autocmd").event

  local win_options = { winhighlight = "Normal:Normal,FloatBorder:Normal" }
  local function border(title)
    return {
      style = "single",
      text = {
        top = "[" .. title .. "]",
        top_align = "left",
      },
    }
  end
  local on_close = function() vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1) end
  local search_text = ""

  local input2 = Input({
    position = "50%",
    size = {
      width = "50%",
      height = 5,
    },
    border = border("Replace"),
    win_options = win_options,
  }, {
    on_close = on_close,
    on_submit = function(value) vim.cmd(":%s/" .. search_text .. "/" .. value .. "/gc") end,
  })

  local input = Input({
    position = "50%",
    size = {
      width = "50%",
      height = 5,
    },
    border = border("Search"),
    win_options = win_options,
  }, {
    on_close = on_close,
    on_submit = function(value)
      vim.cmd("/" .. value)
      input2:mount()
    end,
    on_change = function(v)
      highlight_search_text(v, win, buf)
      search_text = v
    end,
  })

  local Layout = require("nui.layout")
  local layout = Layout(
    {
      position = "50%",
      size = {
        width = "50%",
        height = 5,
      },
    },
    Layout.Box({
      Layout.Box(input, { size = "50%" }),
      Layout.Box(input2, { size = "50%" }),
    }, { dir = "col" })
  )

  input:mount()
  input:on(event.BufDelete, function() end)
end

-- Create the user command to invoke the floating windows (search and replace)
vim.api.nvim_create_user_command("SearchReplaceBox", function()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local word = vim.fn.expand("<cword>")
  vim.print(word)
  popup(word, buf, win)
end, { nargs = 0 }) -- The command takes no argument
