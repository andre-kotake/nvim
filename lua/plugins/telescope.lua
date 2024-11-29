--- @type LazySpec[]
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "benfowler/telescope-luasnip.nvim",
    },
    keys = function(_, keys)
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")
      local pickers = require("plugins.telescope.pickers")
      keys = vim.tbl_deep_extend("force", keys, {
        {
          "<leader>fc",
          function()
            require("telescope.builtin").find_files({
              prompt_title = "Config Files",
              cwd = vim.fn.stdpath("config"),
              hidden = true,
            })
          end,
          desc = "Config files",
        },
        {
          "<leader>fP",
          function()
            local t = require("telescope")
            t.extensions["nvim-chezmoi"].managed(require("telescope.themes").get_ivy({
              border = false,
              preview = {
                check_mime_type = true,
              },
              layout_config = {
                preview_cutoff = 1, -- Preview should always show (unless previewer = false)

                width = function(_, max_columns, _) return math.min(max_columns, 80) end,

                height = function(_, _, max_lines) return math.min(max_lines, 15) end,
              },
            }))
          end,
          desc = "Project files",
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
          function()
            builtin.help_tags(themes.get_ivy({
              border = false,
              layout_config = {
                preview_cutoff = 1, -- Preview should always show (unless previewer = false)
              },
            }))
          end,
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
      require("telescope").load_extension("luasnip")
      require("telescope-tabs").setup(opts)
    end,
  },
}
