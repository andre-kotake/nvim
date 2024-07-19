-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local M = {}

local utils = require("util")
local maps = utils.get_mappings_template()

maps.n["<leader>xz"] = {
  function()
    vim.diagnostic.open_float(nil, { border = "single" })
  end,
  desc = "Line Diagnostics",
}

maps.n["<leader>/"] = { "gcc", remap = false, desc = "Toggle comment line" }
maps.x["<leader>/"] = { "gc", remap = false, desc = "Toggle comment" }

utils.set_mappings(maps)

return M
