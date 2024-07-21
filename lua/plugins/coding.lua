local has_words_before = function()
  if string.match(vim.fn.mode(), "^c") then
    return true
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.api.nvim_buf_get_lines(0, line - 1, line, true)
  return col ~= 0 and lines[1]:sub(col, col):match("%s") == nil
end

return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local win_opt = {
        border = "single",
        col_offset = 0,
        side_padding = 2,
      }
      local doc_opt = {
        col_offset = 0,
        side_padding = 2,
        winhighlight = "Normal:PopMenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      }
      opts.completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      }

      opts.matching = {
        -- Allow only prefix matching!
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = true,
        disallow_prefix_unmatching = true,
      }

      opts.preselect = "None"
      opts.window = {
        completion = cmp.config.window.bordered(win_opt),
        documentation = cmp.config.window.bordered(doc_opt),
      }

      opts.experimental = {
        ghost_text = false,
      }

      local mapping = {
        -- Smart unobtrusive completion in a shell-like way.
        --
        --  - Menu is shown only when user explicitly asks for it and there are
        --    multiple possible completions/snippets available.
        --  - Normal editing keys works as usually even if menu is shown:
        --    - Completion menu might be shown only on <Tab> after word or <S-Tab>.
        --    - Item in menu can be selected only by extra <Tab> or <S-Tab>.
        --    - Behaviour of these keys changes only when menu item is selected
        --      (i.e. after at least two <Tab> or <S-Tab>, meaning active
        --      interaction with menu):
        --      - <CR> completes/expands current item.
        --      - <C-Down>, <C-Up> scroll current item docs.
        --  - <Tab> action for a current word, with or without menu opened:
        --    - If there only one possible snippet then expand it.
        --    - If there only one possible completion then complete it.
        --    - If there only one possible partial completion then complete it.
        --    - If there are multiple possible completions then:
        --      - If menu isn't opened then open menu (without selecting anything,
        --        so it serves as a hint what you can type next).
        --      - If menu is opened then select next item.
        --  - <S-Tab> action:
        --    - If menu is opened then select previous item.
        --    - If menu is not opened then open menu (useful on empty line).
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if cmp.complete_common_string() then
              return
            elseif #cmp.get_entries() == 1 then
              cmp.confirm({ select = true })
            else
              cmp.select_next_item({
                behavior = cmp.SelectBehavior.Select,
              })
            end
          elseif has_words_before() then
            cmp.complete()
            if cmp.complete_common_string() then
              cmp.close()
            elseif #cmp.get_entries() == 1 then
              cmp.confirm({
                select = true,
              })
            end
          else
            fallback()
          end
        end, { "i", "c" }),
        ["<S-Tab>"] = cmp.mapping(function(_)
          if cmp.visible() then
            cmp.select_prev_item({
              behavior = cmp.SelectBehavior.Select,
            })
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<CR>"] = cmp.mapping(function(fallback)
          if not cmp.confirm({ select = false }) then
            fallback()
          end
        end, { "i", "c" }),
        ["<C-e>"] = cmp.mapping(function(fallback)
          if not cmp.abort() then
            fallback()
          end
        end, { "i", "c" }),
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, mapping)
      -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
      --
      --   ["<CR>"] = cmp.mapping({
      --     i = function(fallback)
      --       if cmp.visible() and cmp.get_active_entry() then
      --         cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
      --       else
      --         fallback()
      --       end
      --     end,
      --     s = cmp.mapping.confirm({ select = true }),
      --     c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      --   }),
      --   ["<Tab>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       if #cmp.get_entries() == 1 then
      --         cmp.confirm({ select = true })
      --       else
      --         cmp.select_next_item()
      --       end
      --     --[[ Replace with your snippet engine (see above sections on this page)
      -- elseif snippy.can_expand_or_advance() then
      --   snippy.expand_or_advance() ]]
      --     elseif has_words_before() then
      --       cmp.complete()
      --       if #cmp.get_entries() == 1 then
      --         cmp.confirm({ select = true })
      --       end
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      -- })

      -- Use <tab> for completion and snippets (supertab).
      -- local has_words_before = function()
      --   unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      -- end
      --
      -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
      --   ["<Tab>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
      --       -- cmp.select_next_item()
      --       cmp.confirm({ select = true })
      --     elseif vim.snippet.active({ direction = 1 }) then
      --       vim.schedule(function()
      --         vim.snippet.jump(1)
      --       end)
      --     elseif has_words_before() then
      --       cmp.complete()
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      --   ["<S-Tab>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       cmp.select_prev_item()
      --     elseif vim.snippet.active({ direction = -1 }) then
      --       vim.schedule(function()
      --         vim.snippet.jump(-1)
      --       end)
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      -- })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        yaml = { "yamllint" },
      },
    },
  },
}
