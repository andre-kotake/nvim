return {
  "williamboman/mason.nvim",
  cmd = { "MasonInstallAll" },
  opts = function(_, opts)
    return K_Lazy.merge(opts, K_Lazy.mason)
  end,
  init = function()
    K_Lazy.mason.install_all_user_command()
  end,
}
