require("core.options")
require("core.autocmds")
require("core.lazy")
require("core.keymaps")

-- Load colorscheme
if vim.g.colorscheme then vim.cmd.colorscheme(vim.g.colorscheme) end

require("core.highlights")
