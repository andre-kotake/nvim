local lua_packages = { "lua-language-server", "stylua" }

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",

        "shellcheck",
        "shellharden",
        "shfmt",

        "yamlfix",
        "yamllint",
      },
      PATH = "append",
      pip = {
        install_args = { "--verbose", "--prefer-binary" },
      },
      ui = {
        border = "double",
        width = 1,
        height = 1,
      },
    },
    init = function()
      if K_Global.is_android then
        local registry = require("mason-registry")

        registry:once(
          "package:install:failed",
          vim.schedule_wrap(function(pkg, handle)
            for _, lua_pkg in pairs(lua_packages) do
              if pkg.name == lua_pkg then
                pkg:install({
                  target = "linux_arm64_gnu",
                })
              end
            end
          end)
        )
      end
    end,
  },
}
