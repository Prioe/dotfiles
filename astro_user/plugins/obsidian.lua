-- Necessary to render a few extra ui features like checkboxes
-- See: https://github.com/epwalsh/obsidian.nvim/issues/286
vim.opt.conceallevel = 1

return {
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  {
    "epwalsh/obsidian.nvim",
    event = {
      "BufReadPre */notes/**.md",
      "VeryLazy",
    },
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
      completion = {
        min_chars = 1,
      },
    },
  },
}
