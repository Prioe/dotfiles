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

      note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = vim.ui.open,
    }

    return astrocore.extend_tbl(opts, obsidian_opts)
  end,
}
