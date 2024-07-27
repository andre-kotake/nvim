--- @class k_lazy.utils.mason
local M = {
  ensure_installed = {
    "lua-language-server",
    "stylua",
    "selene",

    "bash-language-server",
    "shellcheck",
    "shellharden",
    "shfmt",

    "json-lsp",
    "jsonlint",

    "taplo",

    "yaml-language-server",
    "yamlfix",
    "yamllint",
  },
  providers = {
    "mason.providers.client",
    "mason.providers.registry-api",
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
}

function M.refresh_registry()
  local registry = require("mason-registry")

  -- registry:on("package:install:success", function()
  --   vim.defer_fn(function()
  --     -- trigger FileType event to possibly load this newly installed LSP server
  --     require("lazy.core.handler.event").trigger({
  --       event = "FileType",
  --       buf = vim.api.nvim_get_current_buf(),
  --     })
  --   end, 100)
  -- end)

  registry.refresh(function()
    local is_ui_open = false
    for _, package in ipairs(M.ensure_installed) do
      if not registry.is_installed(package) then
        if not is_ui_open then
          require("mason.ui").open()
          is_ui_open = true
        end

        local p = registry.get_package(package)
        p:install()
      end
    end
  end)
end

function M.install_all_user_command()
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    M.refresh_registry()
  end, {})
end

return M
