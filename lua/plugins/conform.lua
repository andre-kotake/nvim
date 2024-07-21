return {
  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = true,

      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shellharden", "shfmt" },
        yaml = { "yamlfix" },
      },
      formatters = {

        shfmt = {
          prepend_args = { "-i", "2", "-ci", "-bn", "-s" },
        },

        yamlfix = {
          -- prepend_args = {
          -- "--config-file",
          -- K_Global.path.config .. "yamlfix/config.toml",
          -- },
          env = {
            YAMLFIX_WHITELINES = "1",
            YAMLFIX_SECTION_WHITELINES = "1",
            YAMLFIX_COMMENTS_WHITELINES = "2",
            YAMLFIX_SEQUENCE_STYLE = "block_style",
          },
        },
      },
    },
  },
}
