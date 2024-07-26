local view_max_width = math.floor(vim.o.columns * 0.90)
local function get_msg_show_find_patterns()
  -- Message patterns to skip.
  local find_patterns = {
    "more line",
    "line less",
    "fewer lines",
    "clipboard: No provider.",
    "change; before",
  }

  return vim.tbl_map(function(pattern)
    return { find = pattern }
  end, find_patterns)
end

return {
  "folke/noice.nvim",
  -- enabled = false,
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        size = {
          width = "85%",
        },
      },
      cmdline_popupmenu = {
        size = {
          width = "85%",
        },
      },
      -- confirm = {
      --   size = {
      --     max_width = view_max_width,
      --   },
      -- },
      hover = {
        size = {
          max_width = view_max_width,
        },
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = get_msg_show_find_patterns(),
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local client = vim.tbl_get(message.opts, "progress", "client")
            return client == "lua_ls"
          end,
        },
        opts = { skip = true },
      },
    },
  },
}
