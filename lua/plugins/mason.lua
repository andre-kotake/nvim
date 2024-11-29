--- @type LazySpec[]
return {
  ------------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonLog",
    },
    build = function()
      pcall(function() require("mason-registry").refresh() end)
    end,
    opts = {
      icons = {
        package_installed = "◍ ",
        package_pending = "◍ ",
        package_uninstalled = "◍ ",
      },
      ui = {
        check_outdated_packages_on_open = true,
        width = 1,
        height = 1,
        border = "double",
        keymaps = {
          toggle_package_expand = "<CR>",
          install_package = "i",
          update_package = "u",
          check_package_version = "c",
          update_all_packages = "U",
          check_outdated_packages = "C",
          uninstall_package = "x",
          cancel_installation = "<C-c>",
          apply_language_filter = "<C-f>",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      local excludes = {}
      -- lua-language-server should be installed from Termux itself.
      if os.getenv("TERMUX_VERSION") then
        excludes[#excludes + 1] = "lua_ls"

        -- local required = { "lua-language-server", "stylua" }
        -- for i = #required, 1, -1 do
        --   if vim.fn.executable(required[i]) == 1 then table.remove(required, i) end
        -- end
        --
        -- if #required > 1 then
        --   local jobs = require("plenary.job")
        --   jobs
        --     :new({
        --       command = "pkg",
        --       args = { "install", "lua-language-server", "-y", "--noconfirm" },
        --       on_start = function() vim.notify("Installing packages...", vim.log.levels.INFO, {}) end,
        --       on_exit = function(job, code, signal)
        --         vim.print("Installed packages:\n" .. table.concat(required, "\n - "))
        --       end,
        --     })
        --     :start()
        -- end
      end

      require("mason-lspconfig").setup({
        automatic_installation = {
          exclude = excludes,
        },
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    config = function()
      local ensure_installed = {
        "stylua",
        "selene",
        "shellharden",
        "shfmt",
      }

      if os.getenv("TERMUX_VERSION") then
        local utils = require("core.utils.table")
        utils.remove_item(ensure_installed, "stylua")
        utils.remove_item(ensure_installed, "selene")
      end

      require("mason-null-ls").setup({
        automatic_installation = false,
        ensure_installed = ensure_installed,
      })
    end,
  },
}
