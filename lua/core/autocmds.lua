--- @param event any
--- @param opts vim.api.keyset.create_autocmd
local function define_autocmd(event, opts)
  if type(opts.group) == "string" and opts.group ~= "" then
    local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
    if not exists then vim.api.nvim_create_augroup(opts.group, {}) end
  end
  vim.api.nvim_create_autocmd(event, opts)
end

--- @param definitions table contains a tuple of event, opts, see `:h nvim_create_autocmd`
local function define_autocmds(definitions)
  for _, entry in ipairs(definitions) do
    local event = entry[1]
    local opts = entry[2]
    if opts.enabled ~= false then define_autocmd(event, opts) end
  end
end

--- @type { [string]: vim.api.keyset.create_autocmd}[]
local definitions = {
  {
    "TextYankPost",
    {
      group = "_general_settings",
      pattern = "*",
      desc = "Highlight text on yank",
      callback = function() vim.highlight.on_yank({ higroup = "Search", timeout = 100 }) end,
    },
  },
  {
    "FileType",
    {
      group = "_buffer_mappings",
      desc = "Wrap help",
      pattern = {
        "man",
        "help",
      },
      callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.colorcolumn = "0"
      end,
    },
  },
  {
    "FileType",
    {
      group = "_buffer_mappings",
      desc = "Close on <q> ",
      pattern = {
        "qf",
        "man",
        "floaterm",
        "lspinfo",
        "lir",
        "lsp-installer",
        "null-ls-info",
        "tsplayground",
        "DressingSelect",
        "Jaq",
        "PlenaryTestPopup",
        "grug-far",
        "help",
        "notify",
        "spectre_panel",
        "startuptime",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
        "dbout",
        "gitsigns.blame",
        "[Scratch]",
        "neo-tree",
      },
      callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
        vim.opt_local.buflisted = false
        -- vim.opt_local.laststatus=0
      end,
    },
  },
  {
    "FileType",
    {
      group = "_buffer_mappings",
      desc = "Close on <q> ",
      pattern = {
        "neo-tree",
      },
      callback = function() vim.opt_local.numberwidth = 1 end,
    },
  },
  {
    "VimResized",
    {
      group = "_auto_resize",
      pattern = "*",
      command = "tabdo wincmd =",
    },
  },
  {
    "FileType",
    {
      group = "_filetype_settings",
      pattern = "alpha",
      callback = function()
        vim.cmd([[
            set nobuflisted
          ]])
      end,
    },
  },
  {
    "FileType",
    {
      group = "_filetype_settings",
      pattern = "lir",
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end,
    },
  },
  { -- taken from AstroNvim
    { "BufRead", "BufWinEnter", "BufNewFile" },
    {
      group = "_file_opened",
      nested = true,
      callback = function(args)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
        if not (vim.fn.expand("%") == "" or buftype == "nofile") then
          vim.api.nvim_del_augroup_by_name("_file_opened")
          vim.api.nvim_exec_autocmds("User", { pattern = "FileOpened" })
          -- TODO: Talvez carregar sempre LSP aqui ao invés de automatico através do lazy
          -- require("lvim.lsp").setup()
        end
      end,
    },
  },
  {
    { "BufReadPost" },
    {
      group = "_file_opened",
      once = true,
      callback = function(event)
        -- Skip if we already entered vim
        if vim.v.vim_did_enter == 1 then return end

        -- Try to guess the filetype (may change later on during Neovim startup)
        local ft = vim.filetype.match({ buf = event.buf })
        if ft then
          -- Add treesitter highlights and fallback to syntax
          local lang = vim.treesitter.language.get_lang(ft)
          if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then vim.bo[event.buf].syntax = ft end

          -- Trigger early redraw
          vim.cmd([[redraw]])
        end
      end,
    },
  },
  {
    { "UIEnter", "ColorScheme" },
    {
      callback = function()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        if not normal.bg then return end
        io.write(string.format("\027]11;#%06x\027\\", normal.bg))
      end,
    },
  },
  {
    "UILeave",
    {
      callback = function() io.write("\027]111\027\\") end,
    },
  },
  {
    "TermOpen",
    {
      callback = function(ev)
        vim.api.nvim_buf_set_keymap(ev.buf, "t", "<Esc>", [[<C-\><C-n>]], {
          noremap = true,
          silent = true,
        })
      end,
    },
  },
  {
    "BufWritePre",
    {
      desc = "Automatically create parent directories if they don't exist when saving a file",
      callback = function(args)
        local buf_is_valid_and_listed = vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].buflisted
        if buf_is_valid_and_listed then
          vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(args.match) or args.match, ":p:h"), "p")
        end
      end,
    },
  },
  -- {
  --   "BufWritePre",
  --   {
  --     group = "LspFormatting",
  --     desc = "Format on save",
  --     callback = function(args)
  --       if Validate.is_valid_buf(args.buf) then
  --         require("config.lsp.utils").format()
  --       end
  --     end,
  --   },
  -- },
  ----------------------------------------------------------------------------
}

define_autocmds(definitions)
