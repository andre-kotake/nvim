local function bootstrap_lazy()
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end

  vim.opt.rtp:prepend(lazypath)
end

local function setup_lazy()
  local lazy_event = require("lazy.core.handler.event")
  lazy_event.mappings.FileStart = {
    id = "FileStart",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  }

  require("lazy").setup({

    spec = {
      { import = "plugins" },
    },

    -- automatically check for plugin updates
    checker = { enabled = false },
    defaults = { lazy = true },
    change_detection = { enabled = false },
    install = { colorscheme = { vim.g.colorscheme } },
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "tarPlugin",
          "tohtml",
          -- "tutor",
          "zipPlugin",
        },
      },
    },
    ui = {
      size = { width = 1, height = 1 },
      border = "double",
    },
  })
end

bootstrap_lazy()
setup_lazy()
