local utils = require("heirline.utils")
local space = "\u{00A0}"

local condition = function()
  local bufnr = vim.api.nvim_get_current_buf()

  return vim.api.nvim_get_option_value("modifiable", { buf = bufnr })
    or not vim.api.nvim_get_option_value("readonly", { buf = bufnr })
end

local linenum = {
  init = function(self)
    -- Get the width required for the max_lnum (number of characters in max_lnum)
    self.width = #tostring(vim.api.nvim_buf_line_count(self.bufnr))
  end,
  provider = function(self)
    local lnum = tostring(self.lnum)
    return string.rep(space, self.width - #lnum) .. lnum
  end,
  condition = function() return vim.opt.number:get() and condition() end,
}

-- local diagnostics = {
--   init = function(self)
--     self.diagnostics = vim.diagnostic.get(self.bufnr, { lnum = self.lnum - 1 })
--     if #self.diagnostics > 0 then
--       self.severity = self.diagnostics[1].severity
--       self.highlight_info = utils.get_highlight(self.diagnostic_hl[self.severity])
--     end
--   end,
--   static = {
--     diagnostic_hl = {
--       [vim.diagnostic.severity.ERROR] = "DiagnosticError",
--       [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
--       [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
--       [vim.diagnostic.severity.HINT] = "DiagnosticHint",
--     },
--   },
--   condition = require("heirline.conditions").has_diagnostics,
--   provider = function(self)
--     if #self.diagnostics == 0 then return "\u{00A0}" end
--     return vim.g.signs[self.severity]
--   end,
--   hl = function(self)
--     if #self.diagnostics > 0 then
--       return { fg = self.highlight_info.fg }
--     end
--   end,
-- }

local foldcolumn = {
  -- init = function(self) self.fillchars = vim.opt.fillchars:get() end,
  static = { fillchars = vim.opt.fillchars:get() },
  provider = function(self)
    -- Nvim C Extensions
    local ffi = require("ffi")

    -- Custom C extension to get direct fold information from Neovim
    local ok, fold = pcall(function()
      ffi.cdef([[
      	typedef struct {} Error;
	      typedef struct {} win_T;
    	  typedef struct {
    		  int start;  // line number where deepest fold starts.
  		    int level;  // fold level, when zero other fields are N/A.
	        int llevel; // lowest level that starts in v:lnum.
      	  int lines;  // number of lines from v:lnum to end of closed fold.
      	} foldinfo_T;
    	  foldinfo_T fold_info(win_T* wp, int lnum);
    	  win_T *find_window_by_handle(int Window, Error *err);
  	    int compute_foldcolumn(win_T *wp, int col);
      ]])

      local wp = ffi.C.find_window_by_handle(0, ffi.new("Error")) -- get window handler
      local width = ffi.C.compute_foldcolumn(wp, 0) -- get foldcolumn width
      -- get fold info of current line
      local foldinfo = width > 0 and ffi.C.fold_info(wp, vim.v.lnum) or { start = 0, level = 0, llevel = 0, lines = 0 }

      if width ~= 0 then
        if foldinfo.level == 0 then
          return space
        else
          local closed = foldinfo.lines > 0
          local first_level = foldinfo.level - width - (closed and 1 or 0) + 1
          if first_level < 1 then first_level = 1 end

          for col = 1, width do
            if vim.v.virtnum ~= 0 then return self.fillchars.foldsep end

            if closed and (col == foldinfo.level or col == width) then return self.fillchars.foldclose end
            if foldinfo.start == vim.v.lnum and first_level + col > foldinfo.llevel then
              return self.fillchars.foldopen
            end
          end
        end
      end
    end)

    local foldsign = (ok and fold ~= nil and fold) or space
    return foldsign .. space
  end,
  on_click = {
    callback = function(self)
      local function statuscolumn_clickargs()
        local args = { mousepos = vim.fn.getmousepos() }
        args.char = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol)

        if args.char == space or args.char == " " then
          args.char = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol - 1)
        end

        vim.api.nvim_set_current_win(args.mousepos.winid)
        vim.api.nvim_win_set_cursor(0, { args.mousepos.line, 0 })

        return args
      end

      local char = statuscolumn_clickargs().char
      if char == self.fillchars.foldopen then
        vim.cmd("norm! zc")
      elseif char == self.fillchars.foldclose then
        vim.cmd("norm! zo")
      end
    end,
    name = "heirline_fold",
  },
}

local signs = {
  init = function(self)
    local resolve_sign = function(bufnr, lnum)
      local row = lnum - 1
      local extmarks = vim.api.nvim_buf_get_extmarks(
        bufnr,
        -1,
        { row, 0 },
        { row, -1 },
        { details = true, type = "sign" }
      )

      local ret
      for _, extmark in pairs(extmarks) do
        local sign_def = extmark[4]
        if sign_def.sign_text and (not ret or (ret.priority < sign_def.priority)) then ret = sign_def end
        if ret then
          return {
            text = ret.sign_text,
            texthl = utils.get_highlight(ret.sign_hl_group),
          }
        end
      end
    end

    self.sign = resolve_sign(self.bufnr, self.lnum)
  end,
  provider = function(self)
    if self.sign then return space .. self.sign.text end
    return " ┃ "
  end,
  hl = function(self)
    if self.sign then return { fg = self.sign.texthl.fg } end
  end,
  on_click = {
    callback = function() vim.cmd("Gitsigns preview_hunk") end,
    name = "heirline_preview_hunk",
  },
}

-- local separator = { provider = function() return "\u{00A0}" end }

return {
  init = function(self)
    self.bufnr = vim.api.nvim_get_current_buf()
    self.lnum = vim.v.lnum
    self.fg = utils.get_highlight("LineNr").fg
    self.bg = utils.get_highlight("NeoTreeNormal").bg
  end,
  hl = function(self) return { fg = self.fg, bg = self.bg } end,
  condition = condition,
  foldcolumn,
  linenum,
  signs,
}
