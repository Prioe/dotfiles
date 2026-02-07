---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  event = {
    "BufReadPre */notes/**.md",
    "BufNewFile */notes/**.md",
    "VeryLazy",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "hrsh7th/nvim-cmp", optional = true },
    { "Saghen/blink.cmp", optional = true },
    { "folke/snacks.nvim", optional = true },
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        options = {
          opt = {
            conceallevel = 1,
          },
        },
        mappings = {
          n = {
            ["gf"] = {
              function()
                if require("obsidian").util.cursor_on_markdown_link() then
                  return "<Cmd>Obsidian follow_link<CR>"
                else
                  return "gf"
                end
              end,
              desc = "Obsidian Follow Link",
            },
            ["<leader>N"] = { name = "󱓧 Notes" },
            ["<leader>Nn"] = { ":Obsidian new<CR>", desc = "[N]ew note" },
            ["<leader>Nt"] = { ":Obsidian today<CR>", desc = "Open [t]odays daily note" },
            ["<leader>No"] = { ":Obsidian open<CR>", desc = "[O]pen current note" },
            ["<leader>Nf"] = { ":Obsidian search<CR>", desc = "[F]ind Notes" },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    ---@type obsidian.config.ClientOpts | table<string, any>
    local obsidian_opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "personal",
          path = "~/notes",
        },
      },
      notes_subdir = "notes",
      new_notes_location = "notes_subdir",
      open = {
        use_advanced_uri = true,
      },
      ---@type obsidian.config.DailyNotesOpts | table<string, any>
      daily_notes = {
        folder = "notes/dailies",
      },

      ---@type obsidian.config.TemplateOpts | table<string, any>
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },

      ---@type obsidian.config.CompletionOpts | table<string, any>
      completion = {
        min_chars = 1,
      },
    }

    return astrocore.extend_tbl(opts, obsidian_opts)
  end,
}
