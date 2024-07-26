-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Options --------------------------------------------------------------------
vim.opt.cmdheight = 0 -- Hide command line unless needed.

vim.opt.colorcolumn = "80" -- PEP8 like character limit vertical bar.
vim.opt.scrolloff = 1000 -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
vim.o.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.whichwrap:append("<>[]hl") -- go to previous/next line when cursor reaches end/beginning of line

-- Globals --------------------------------------------------------------------
vim.g.mapleader = " " -- Set leader key.
vim.g.maplocalleader = "," -- Set default local leader key.
vim.g.big_file = { size = 1024 * 100, lines = 10000 } -- For files bigger than this, disable 'treesitter' (+100kb).

-- The next globals are toggleable with <space + l + u>
-- vim.g.autoformat_enabled = false -- Enable auto formatting at start.
-- vim.g.autopairs_enabled = false -- Enable autopairs at start.
-- vim.g.cmp_enabled = true -- Enable completion at start.
-- vim.g.codeactions_enabled = true -- Enable displaying 💡 where code actions can be used.
-- vim.g.codelens_enabled = true -- Enable automatic codelens refreshing for lsp that support it.
-- vim.g.diagnostics_mode = 3 -- Set code linting (0=off, 1=only show in status line, 2=virtual text off, 3=all on).
vim.g.icons_enabled = true -- Enable icons in the UI (disable if no nerd font is available).
-- vim.g.inlay_hints_enabled = false -- Enable always show function parameter names.
-- vim.g.lsp_round_borders_enabled = true -- Enable round borders for lsp hover and signatureHelp.
-- vim.g.lsp_signature_enabled = true -- Enable automatically showing lsp help as you write function parameters.
-- vim.g.notifications_enabled = true -- Enable notifications.
-- vim.g.semantic_tokens_enabled = true -- Enable lsp semantic tokens at start.
-- vim.g.url_effect_enabled = true -- Highlight URLs with an underline effect.
