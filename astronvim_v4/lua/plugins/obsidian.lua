---@type LazySpec
return {
  "epwalsh/obsidian.nvim",
  event = {
    "BufReadPre */notes/**.md",
    "VeryLazy",
  },
  ---@type obsidian.config.ClientOpts | table<string, any>
  opts = {
    -- default astrocommunity config sets this to a path which i dont use
    dir = vim.NIL,
    workspaces = {
      {
        name = "personal",
        path = "~/notes",
      },
    },
    notes_subdir = "notes",
    new_notes_location = "notes_subdir",
    daily_notes = {
      folder = "notes/dailies",
    },
    ---@type obsidian.config.CompletionOpts | table<string, any>
    completion = {
      min_chars = 1,
    },
  },
}
