-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.cmdheight = 0 -- Hide command line unless needed.

-- vim.opt.guicursor = "n:blinkon0,i-ci-ve:ver25" -- Enable cursor blink.
vim.opt.guicursor =
  "n-v:block,i-c-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

-- vim.opt.colorcolumn = "80" -- PEP8 like character limit vertical bar.

vim.g.icons_enabled = true -- Enable icons in the UI (disable if no nerd font is available).
