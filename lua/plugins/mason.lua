return {
  "williamboman/mason.nvim",
  cmd = { "MasonInstallAll" },
  keys = function() end,
  init = function()
    K_Lazy.mason.install_all_user_command()
  end,
  config = function(_, opts)
    local o = K_Lazy.merge(opts, K_Lazy.mason)
    require("mason").setup(o)
  end,
}
