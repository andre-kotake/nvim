-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
LazyVim.lsp.on_attach(function(_, buffer)
  require("better-diagnostic-virtual-text.api").setup_buf(buffer, nil)
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

      vim.diagnostic.open_float({
        scope = "cursor",
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
        source = "if_many",
      })
    end,
  })
end)
