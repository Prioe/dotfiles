return {
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  {
    "epwalsh/obsidian.nvim",
    event = "BufReadPre */notes/**.md",
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
