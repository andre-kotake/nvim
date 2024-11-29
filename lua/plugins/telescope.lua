--- @type LazySpec[]
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {},
    keys = function(_, keys)
      local builtin = require("telescope.builtin")
      local pickers = require("plugins.telescope.pickers")
      keys = vim.tbl_deep_extend("force", keys, {
        {
          "<leader>fc",
          function()
            require("telescope.builtin").git_files({
              prompt_title = "Config Files",
              cwd = vim.fn.stdpath("config"),
              hidden = true,
            })
          end,
          desc = "Config files",
        },
        {
          "<leader>fg",
          builtin.current_buffer_fuzzy_find,
          desc = "Live Grep (buffer)",
        },
        {
          "<leader>fG",
          pickers.live_grep_from_project_git_root,
          desc = "Live Grep (Project)",
        },
        {
          "<leader>fh",
          builtin.help_tags,
          desc = "Help",
        },
        {
          "<leader>fp",
          pickers.project_files,
          desc = "Project files",
        },
      })

      return keys
    end,
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      return vim.tbl_deep_extend("force", {
        defaults = {
          borderchars = { "─", "║", "─", "║", "╓", "╖", "╜", "╙" },
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          layout_config = {
            prompt_position = "top",
            vertical = {
              mirror = true,
              width = 0.9,
            },
          },
          file_ignore_patterns = {
            ".git/",
          },
          mappings = {
            n = {
              ["<C-p>"] = action_layout.toggle_preview,
            },
            i = {
              ["<esc>"] = actions.close,
              ["<C-p>"] = action_layout.toggle_preview,
            },
          },
        },
      }, opts or {})
    end,
    -- Extensions
  },
  {
    "LukasPietzschmann/telescope-tabs",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>ft",
        function()
          local ivy = require("telescope.themes").get_ivy({
            layout_config = {
              bottom_pane = {
                height = 8,
                preview_cutoff = 120,
                prompt_position = "top",
              },
            },
          })
          require("telescope-tabs").list_tabs(ivy)
        end,
        desc = "Tabs",
      },
    },
    config = function(_, opts)
      require("telescope").load_extension("telescope-tabs")
      require("telescope-tabs").setup(opts)
    end,
  },
}
