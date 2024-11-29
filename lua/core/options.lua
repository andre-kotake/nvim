local set_default_globals = function()
  vim.g.mapleader = " "
  vim.g.colorscheme = "tokyonight" -- "dracula"
  vim.g.big_file = { size = 1024 * 100, lines = 10000 } -- For files bigger than this, disable 'treesitter' (+100kb).

  require("core.utils.ui").toggle_keymap_desc_icons(true)

  vim.g.signs = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.HINT] = "󰌵",
    [vim.diagnostic.severity.INFO] = "",
  }
end

local set_default_options = function()
  local default_options = {
    showtabline = 2,
    autochdir = false,
    autowrite = true, -- Enable auto write
    backup = false, -- creates a backup file
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard

    cmdheight = 0, -- more space in the neovim command line for displaying messages
    laststatus = 3,
    showmode = false, -- we don't need to see things like -- INSERT -- anymore

    completeopt = { "menu", "menuone", "noselect" },
    conceallevel = 0, -- so that `` is visible in markdown files
    fileencoding = "utf-8", -- the encoding written to a file
    hidden = true, -- required to keep multiple buffers and open multiple buffers
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    mouse = "a", -- allow the mouse to be used in neovim
    pumheight = 15, -- pop up menu height
    smartcase = true, -- smart case
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = false, -- creates a swapfile
    termguicolors = true, -- set term gui colors (most terminals support this)
    timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
    title = true, -- set the title of window to the value of the titlestring
    -- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
    undofile = true, -- enable persistent undo
    updatetime = 300, -- faster completion
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true, -- convert tabs to spaces
    shiftwidth = 2, -- the number of spaces inserted for each indentation
    tabstop = 2, -- insert 2 spaces for a tab
    cursorline = true, -- highlight the current line
    number = true, -- set numbered lines
    numberwidth = 4, -- set number column width to 2 {default 4}
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    wrap = false, -- display lines as one long line
    scrolloff = 10, -- minimal number of screen lines to keep above and below the cursor.
    showcmd = false, -- show (partial) command in the last line of the screen.
    ruler = true,
    omnifunc = "v:lua.vim.lsp.omnifunc", -- enable completion triggered by <c-x><c-o>

    -- FORMATING OPTIONS
    -- TODO: Comparar com o LazyVim e verificar com o none
    formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})", -- use gq for formatting
    formatoptions = "tro/qn2l1jp",

    confirm = true, -- Confirm to save changes before exiting modified buffer
    colorcolumn = { "80", "120" },
    sessionoptions = {
      "buffers",
      "curdir",
      "tabpages",
      "winsize",
      "help",
      "globals",
      "skiprtp",
    },
    -- ?
    smoothscroll = true,
    keywordprg = ":help",
    selectmode = "key",
    keymodel = "startsel",

    foldtext = "",
    foldlevel = 99,
    foldcolumn = "1",
    foldmethod = "expr", -- folding, set to "expr" for treesitter based folding
    foldexpr = "v:lua.vim.treesitter.foldexpr()",
  }

  --  SETTINGS
  local opt = vim.opt
  opt.spelllang:append("cjk") -- disable spellchecking for asian characters (VIM algorithm does not support it)
  opt.shortmess:append("c") -- don't show redundant messages from ins-completion-menu
  opt.shortmess:append("I") -- don't show the default intro messages
  opt.whichwrap:append("<,>,[,],h,l")

  for k, v in pairs(default_options) do
    opt[k] = v
  end

  vim.schedule(function()
    opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
  end)
  vim.wo.fillchars = "fold: ,foldopen: ,foldclose: " -- Empty fillchars to avoid showing numbers

  -- Customize the fold signs if desired
  vim.opt.fillchars:append({
    foldopen = "",
    foldclose = "",
    fold = "",
    foldsep = " ",
    diff = "/",
    eob = " ",
  })
end

set_default_globals()
set_default_options()

-- opt.grepformat = "%f:%l:%c:%m"
-- opt.grepprg = "rg --vimgrep"
-- opt.ignorecase = true -- Ignore case
-- opt.inccommand = "nosplit" -- preview incremental substitute
-- opt.jumpoptions = "view"
-- opt.linebreak = true -- Wrap lines at convenient points
-- opt.list = true -- Show some invisible characters (tabs...
-- -- opt.pumblend = 10 -- Popup blend
-- opt.pumheight = 10 -- Maximum number of entries in a popup
-- opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
-- opt.shiftround = true -- Round indent
-- opt.shiftwidth = 2 -- Size of an indent
-- opt.shortmess:append({ W = true, I = true, c = true, C = true })
-- opt.sidescrolloff = 20 -- Columns of context
-- opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
-- opt.smartcase = true -- Don't ignore case with capitals
-- opt.smartindent = true -- Insert indents automatically
-- opt.spelllang = { "en" }
-- opt.spelloptions:append("noplainbuffer")
-- opt.splitbelow = true -- Put new windows below current
-- opt.splitkeep = "screen"
-- opt.splitright = true -- Put new windows right of current
-- opt.tabstop = 2 -- Number of spaces tabs count for
-- opt.termguicolors = true -- True color support
-- opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
-- opt.undofile = true
-- opt.undolevels = 10000
-- opt.updatetime = 200 -- Save swap file and trigger CursorHold
-- opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
-- opt.wildmode = "longest:full,full" -- Command-line completion mode
-- opt.winminwidth = 5 -- Minimum window width
-- opt.wrap = false -- Disable line wrap
