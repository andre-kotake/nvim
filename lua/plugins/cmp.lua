---@type LazySpec[]
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      -- { "hrsh7th/cmp-nvim-lsp-signature-help" },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
      "nvim-tree/nvim-web-devicons",
      "L3MON4D3/LuaSnip",
      "windwp/nvim-autopairs",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function()
      local cmp = require("cmp")
      local cmp_formatting = require("plugins.cmp.format")
      return {
        mapping = require("plugins.cmp.mappings"),
        sources = cmp.config.sources({
          -- { name = "nvim_lsp_signature_help" },
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        view = { docs = { auto_open = true } },
        completion = { completeopt = "menu,menuone,noselect" },
        formatting = cmp_formatting.entries,
        window = cmp_formatting.window(),
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        duplicates = {
          lazydev = 1,
          nvim_lsp = 1,
          nvim_lua = 1,
          luasnip = 1,
          buffer = 1,
          path = 1,
        },
        cmdline = {
          options = {
            {
              type = ":",
              sources = {
                { name = "cmdline" },
                { name = "path" },
              },
            },
            {
              type = { "/", "?" },
              sources = {
                { name = "buffer" },
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      for _, option in ipairs(opts.cmdline.options) do
        cmp.setup.cmdline(option.type, {
          view = {
            entries = { name = "custom", selection_order = "near_cursor" },
          },
          sources = option.sources,
          completion = { completeopt = "menu,menuone,noinsert,noselect" },
        })
      end

      -- If you want insert `(` after select function or method item
      local autopairs_ok, cmp_autopairs =
        pcall(require, "nvim-autopairs.completion.cmp")
      if autopairs_ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    build = vim.fn.has("win32") == 0
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
      or nil,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      enable_autosnippets = true,
      history = true,
      updateevents = "TextChanged,TextChangedI",
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      -- vscode format
      require("luasnip.loaders.from_vscode").lazy_load({
        exclude = vim.g.vscode_snippets_exclude or {},
      })
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = vim.g.vscode_snippets_path or "",
      })

      -- snipmate format
      require("luasnip.loaders.from_snipmate").load()
      require("luasnip.loaders.from_snipmate").lazy_load({
        paths = vim.g.snipmate_snippets_path or "",
      })

      -- lua format
      require("luasnip.loaders.from_lua").load()
      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.g.lua_snippets_path or "",
      })

      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if
            require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" }, -- it will not add a pair on that treesitter node
        javascript = { "template_string" },
        java = false, -- Don't check treesitter on java
      },
      -- Don't add pairs if it already has a close pair in the same line
      enable_check_bracket_line = true,
      -- Don't add pairs if the next char is alphanumeric
      ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
      disable_filetype = { "TelescopePrompt", "vim" },
      fast_wrap = {
        -- map = "<C-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        before_key = "h",
        after_key = "l",
        cursor_pos_before = true,
        avoid_move_to_end = true, -- stay for direct end_key use
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        manual_position = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
  },
}
