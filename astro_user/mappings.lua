local utils = require "astronvim.utils"

local is_available = utils.is_available

local icons = {
  Note = "󱓧 ",
}

return {
  n = {
    ["<leader>N"] = { name = icons.Note .. "Notes" },
    ["<leader>Nn"] = { ":ObsidianNew", desc = "New Note" },

    ["<leader>fN"] = { ":ObsidianSearch<CR>", desc = "Find Notes" },
  },
}
