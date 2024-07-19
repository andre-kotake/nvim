-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

if false then
  LazyVim.lsp.on_attach(function(_, buffer)
    -- create the autocmd to show diagnostics
    vim.api.nvim_create_autocmd("CursorHold", {
      group = vim.api.nvim_create_augroup("_auto_diag", { clear = true }),
      buffer = buffer,
      callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.api.nvim_win_get_config(winid).zindex then
            return
          end
        end

        -- local diagnostic_count = #vim.diagnostic.get(0, {})
        vim.diagnostic.open_float({
          scope = "line",
          focusable = false,
          close_events = {
            "BufLeave",
            "BufHidden",
            "CmdlineEnter",
            "CursorMoved",
            "CursorMovedI",
            -- "InsertEnter",
            "InsertCharPre",
            "FocusLost",
          },
          border = "rounded",
          source = true,
        })
      end,
    })
  end)
end

local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  desc = "Automatically toggle wrap on notify windows.",
  pattern = {
    "notify",
  },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- autocmd("LazyFile", {
--   desc = "Show color column.",
--   callback = function()
--     vim.opt_local.colorcolumn = "80"
--   end,
-- })

-- Close all notifications on BufWritePre.
autocmd("BufWritePre", {
  desc = "Close all notifications on BufWritePre",
  callback = function()
    require("notify").dismiss({ pending = true, silent = true })
  end,
})
