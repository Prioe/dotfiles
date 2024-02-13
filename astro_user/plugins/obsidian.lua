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
      dir = vim.env.HOME .. "/notes",
      notes_dir = "notes",
      daily_notes = {
        folder = "notes/dailies",
      },
      new_notes_location = "notes_subdir",
    },
  },
}
