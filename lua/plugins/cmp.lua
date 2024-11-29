---@type LazySpec
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- Sources
    { "hrsh7th/cmp-nvim-lsp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    -- Icons
    { "onsails/lspkind.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    -- Snippets
    {
      "L3MON4D3/LuaSnip",
      dependencies = { { "rafamadriz/friendly-snippets" } },
    },
    { "windwp/nvim-autopairs", config = true },
  },
  event = { "InsertEnter", "CmdlineEnter" },
  opts = function()
    local cmp = require("cmp")
    local cmp_window = require("cmp.config.window")
    return {
      mapping = require("plugins.cmp.mappings"),
      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
      }),
      view = { docs = { auto_open = false } },
      auto_brackets = {
        "lua",
      }, -- configure any filetype to auto add brackets
      completion = { completeopt = "menu,menuone,noinsert" },
      formatting = require("plugins.cmp.format"),
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
      },
      window = {
        completion = cmp_window.bordered({ border = "single" }),
        documentation = cmp_window.bordered({ border = "single" }),
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
        view = { entries = { name = "custom", selection_order = "near_cursor" } },
        sources = option.sources,
        completion = { completeopt = "menu,menuone,noinsert,noselect" },
      })
    end

    require("luasnip.loaders.from_lua").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load()

    -- If you want insert `(` after select function or method item
    local autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if autopairs_ok then cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done()) end
  end,
}
