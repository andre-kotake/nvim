---@type LazySpec
return {
  "rebelot/heirline.nvim",
  -- enabled=false,
  dependencies = {
    { "lewis6991/gitsigns.nvim" },
    { "zeioth/heirline-components.nvim" },
  },
  event = "BufEnter",
  config = function()
    local heirline = require("heirline")
    local heirline_components = require("heirline-components.all")

    -- Setup
    heirline_components.init.subscribe_to_events()
    heirline.load_colors(heirline_components.hl.get_colors())
    heirline.setup({
      tabline = { -- UI upper bar
        heirline_components.component.tabline_conditional_padding(),
        -- heirline_components.component.neotree(),
        heirline_components.component.tabline_buffers(),
        heirline_components.component.fill({ hl = { bg = "tabline_bg" } }),
        -- heirline_components.component.tabline_tabpages(),
      } or nil,
      -- winbar = { -- UI breadcrumbs bar
      --   init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
      --   fallthrough = false,
      --   -- Winbar for terminal, neotree, and aerial.
      --   {
      --     condition = function() return not heirline_components.condition.is_active() end,
      --     {
      --       heirline_components.component.neotree(),
      --       heirline_components.component.compiler_play(),
      --       heirline_components.component.fill(),
      --       heirline_components.component.compiler_build_type(),
      --       heirline_components.component.compiler_redo(),
      --       heirline_components.component.aerial(),
      --     },
      --
      --
      --   },
      --
      --
      --   -- Regular winbar
      --   {
      --     heirline_components.component.neotree(),
      --     heirline_components.component.breadcrumbs(),
      --     heirline_components.component.fill(),
      --     heirline_components.component.compiler_redo(),
      --     heirline_components.component.aerial(),
      --   },
      -- } or nil,
      statuscolumn = require("plugins.heirline.statuscolumn"),
      statusline = { -- UI statusbar
        {
          hl = { fg = "fg", bg = "bg" },
          heirline_components.component.mode({
            mode_text = {},
            -- surround = { separator = "left" },
          }),
          heirline_components.component.cmd_info(),
          heirline_components.component.fill(),
          heirline_components.component.git_branch(),
          heirline_components.component.git_diff(),
          heirline_components.component.diagnostics(),
          -- heirline_components.component.lsp(),
          -- heirline_components.component.compiler_state(),
          -- heirline_components.component.virtual_env(),
          heirline_components.component.file_info(),
          heirline_components.component.nav(),
          heirline_components.component.tabline_tabpages(),
        },
        condition = function() return vim.fn.mode() ~= "c" end,
      } or nil,
      opts = {
        disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
          local is_disabled = not require("heirline-components.buffer").is_valid(args.buf)
            or heirline_components.condition.buffer_matches({
              buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
              filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
            }, args.buf)
          return is_disabled
        end,
      },
    })
  end,
}
