local vault = vim.fn.expand "~/notes"

---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  cmd = "Obsidian",
  event = {
    "BufReadPre " .. vault .. "/**.md",
    "BufNewFile " .. vault .. "/**.md",
  },
  dependencies = {
    { "saghen/blink.cmp", optional = true },
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<leader>N"] = { desc = "󱓧 Notes" },
            ["<leader>Nn"] = { "<Cmd>Obsidian new<CR>", desc = "[N]ew note" },
            ["<leader>Nt"] = { "<Cmd>Obsidian today<CR>", desc = "Open [t]odays daily note" },
            ["<leader>No"] = { "<Cmd>Obsidian open<CR>", desc = "[O]pen current note" },
            ["<leader>Nf"] = { "<Cmd>Obsidian search<CR>", desc = "[F]ind Notes" },
          },
        },
      },
    },
  },
  ---@module "obsidian"
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = "personal", path = vault },
    },
    notes_subdir = "notes",
    new_notes_location = "notes_subdir",
    open = { use_advanced_uri = true },
    daily_notes = { folder = "notes/dailies" },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
    completion = { min_chars = 1 },
    callbacks = {
      enter_note = function()
        vim.opt_local.conceallevel = 1
        vim.keymap.set("n", "gf", function()
          if require("obsidian.api").cursor_link() then return "<Cmd>Obsidian follow_link<CR>" end
          return "gf"
        end, { buffer = true, expr = true, desc = "Obsidian Follow Link" })
      end,
    },
  },
}
