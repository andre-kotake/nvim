return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local function add(lang)
        if type(opts.ensure_installed) == "table" then
          table.insert(opts.ensure_installed, lang)
        end
      end

      vim.filetype.add({
        pattern = {
          [".*/git/[%w]+"] = "gitconfig",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      })

      add("git_config")
      add("gitcommit")
      add("json5")
    end,
  },
}
