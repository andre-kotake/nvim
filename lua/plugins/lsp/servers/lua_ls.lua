return {
  settings = {
    Lua = {
      --     -- Disable built-in formatting to use an external formatter like Stylua
      --     format = false,

      -- Disable telemetry data collection
      telemetry = {
        enable = false,
      },

      workspace = {
        -- Disable checking for third-party libraries
        checkThirdParty = false,

        -- Specify Lua libraries to include in the workspace
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"), -- Lua runtime path
          vim.fn.stdpath("config") .. "/lua", -- User config path for Lua
        },
      },

      -- Enable CodeLens features (inline code actions)
      codelens = {
        enable = true,
      },

      -- Configure completion behavior
      completion = {
        callsnippet = "replace", -- Snippet behavior: replace snippet with the expanded code
      },

      diagnostics = {
        enable = true, -- Enable diagnostics
        globals = { "vim" }, -- Define global variables for linting
        severity = {
          ["missing-doc"] = "Warning", -- Customize severity levels
        },
      },

      -- Document settings for private names (names starting with '_')
      doc = {
        privatename = { "^_" }, -- Treat names starting with '_' as private
      },

      hint = {
        enable = true, -- Enable hinting features
        paramtype = true, -- Show parameter types in hints
        paramname = true, -- Disable parameter name hints
        semicolon = "disable", -- Disable hints for missing semicolons
        arrayindex = "disable", -- Disable hints for array indices
      },
    },
  },
}
