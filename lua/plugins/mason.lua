local mason = require("utils.mason")

return {
  "williamboman/mason.nvim",
  cmd = { "MasonInstallAll" },
  keys = function() end,
  config = function(_, opts)
    local o = K_Lazy.merge(opts, mason)
    require("mason").setup(o)

    K_Lazy.mason.install_all_user_command()
  end,
}
