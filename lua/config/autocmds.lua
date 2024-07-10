-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
LazyVim.lsp.on_attach(function(_, buffer)
  -- create the autocmd to show diagnostics
  vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("_auto_diag", { clear = true }),
    buffer = buffer,
    callback = function()
      local opts = {
        focusable = false,
        close_events = {
          "BufLeave",
          "CmdlineEnter",
          "CursorMoved",
          "CursorMovedI",
          -- "InsertEnter",
          "FocusLost",
        },
        border = "single",
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
end)
