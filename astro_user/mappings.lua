local utils = require "astronvim.utils"

local is_available = utils.is_available

local icons = {
  Note = "󱓧 ",
}

return {
  n = {
    ["<leader>N"] = { name = icons.Note .. "Notes" },
    ["<leader>Nn"] = { ":ObsidianNew<CR>", desc = "[N]ew note" },
    ["<leader>Nt"] = { ":ObsidianToday<CR>", desc = "Open [t]odays daily note" },
    ["<leader>No"] = { ":ObsidianOpen<CR>", desc = "[O]pen current note" },

    ["<leader>fN"] = { ":ObsidianSearch<CR>", desc = "Find Notes" },
  },
}
