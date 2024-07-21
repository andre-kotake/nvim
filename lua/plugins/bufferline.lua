_G.__cached_neo_tree_selector = nil
_G.__get_selector = function()
  return _G.__cached_neo_tree_selector
end

return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            raw = " %{%v:lua.__get_selector()%} ",
            highlight = { sep = { link = "WinSeparator" } },
            separator = "┃",
          },
        },
      },
    },
  },
}
