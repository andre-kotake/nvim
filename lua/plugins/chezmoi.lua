local pick_chezmoi = function()
  if LazyVim.pick.picker.name == "telescope" then
    require("telescope").extensions.chezmoi.find_files()
  elseif LazyVim.pick.picker.name == "fzf" then
    local fzf_lua = require("fzf-lua")
    local results = require("chezmoi.commands").list({})
    local chezmoi = require("chezmoi.commands")

    local opts = {
      fzf_opts = {},
      fzf_colors = false,
      actions = {
        ["default"] = function(selected)
          chezmoi.edit({
            targets = { "~/" .. selected[1] },
            args = { "--watch" },
          })
        end,
      },
    }
    fzf_lua.fzf_exec(results, opts)
  end
end

return {
  {
    -- highlighting for chezmoi files template files
    "alker0/chezmoi.vim",
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
      vim.g["chezmoi#source_dir_path"] = os.getenv("HOME") .. "/.local/share/chezmoi"

      vim.filetype.add({
        filename = {
          [".chezmoi.toml.tmpl"] = "toml",
          [".chezmoi.jsonc.tmpl"] = "jsonc",
        },
      })
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    lazy = true,
    opts = {
      edit = {
        watch = true,
        force = false,
      },
      notification = {
        on_open = true,
        on_apply = true,
        on_watch = true,
      },
      telescope = {
        select = { "<CR>" },
      },
    },
    init = function()
      -- run chezmoi edit on file enter
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/home/*" },
        callback = function()
          vim.schedule(function()
            require("chezmoi.commands.__edit").watch()
            local ft = string.gsub(vim.bo.filetype, ".chezmoitmpl", "")
            -- LazyVim.info(ft, {})
            vim.bo.filetype = ft
            --vim.treesitter.start(args.buf, ft)
          end)
        end,
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      local projects = {
        action = pick_chezmoi,
        desc = "  Chezmoi",
        icon = "",
        key = "z",
      }

      projects.desc = projects.desc .. string.rep(" ", 20 - #projects.desc)
      projects.key_format = "  %s"

      table.insert(opts.config.center, 6, projects)
    end,
  },
}
