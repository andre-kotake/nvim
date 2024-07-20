-- TODO: Melhorar essas cores
local _hl_groups = {
  { group = "RainbowRed", highlight = { fg = "#E06C75" } },
  { group = "RainbowYellow", highlight = { fg = "#E5C07B" } },
  { group = "RainbowBlue", highlight = { fg = "#61AFEF" } },
  { group = "RainbowOrange", highlight = { fg = "#D19A66" } },
  { group = "RainbowGreen", highlight = { fg = "#98C379" } },
  { group = "RainbowViolet", highlight = { fg = "#C678DD" } },
  { group = "RainbowCyan", highlight = { fg = "#56B6C2" } },
}

local _hl = vim.tbl_map(function(item)
  return item.group
end, _hl_groups)

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = { highlight = _hl },
      scope = { highlight = _hl },
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")

      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for _, v in pairs(_hl_groups) do
          K_Utils.set_hl_attributes(v.group, v.highlight)
        end
      end)

      require("ibl").setup(opts)

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "LazyFile" },
    setup = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = _hl,
      })
    end,
  },
}
