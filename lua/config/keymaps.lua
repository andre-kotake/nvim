-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local M = {}

local map = vim.keymap.set

map("n", ";", ":", { desc = "Enter Command Mode", silent = false, noremap = true })

map({ "i", "n" }, "<C-f>", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

local utils = require("util")
local maps = utils.get_mappings_template()

maps.n["<leader>xz"] = {
  function()
    vim.diagnostic.open_float(nil, { border = "single" })
  end,
  desc = "Line Diagnostics",
}

-- maps.n[";"] = { ":", desc = "Enter Command Mode", silent = false }

maps.n["<leader>/"] = { "gcc", remap = true, desc = "Toggle comment line" }
maps.x["<leader>/"] = { "gc", remap = true, desc = "Toggle comment" }

-- vim.keymap.set("n", ";", ":", { desc = "Enter Command Mode" })

utils.set_mappings(maps, {
  silent = true,
})

return M
