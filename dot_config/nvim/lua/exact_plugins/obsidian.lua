---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  event = {
    "BufReadPre */notes/**.md",
    "VeryLazy",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "hrsh7th/nvim-cmp", optional = true },
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
                  return "<Cmd>ObsidianFollowLink<CR>"
                else
                  return "gf"
                end
              end,
              desc = "Obsidian Follow Link",
            },
            ["<leader>N"] = { name = "󱓧 Notes" },
            ["<leader>Nn"] = { ":ObsidianNew<CR>", desc = "[N]ew note" },
            ["<leader>Nt"] = { ":ObsidianToday<CR>", desc = "Open [t]odays daily note" },
            ["<leader>No"] = { ":ObsidianOpen<CR>", desc = "[O]pen current note" },
            ["<leader>Nf"] = { ":ObsidianSearch<CR>", desc = "[F]ind Notes" },
          },
        },
      },
    },
  },
  ---@type obsidian.config.ClientOpts | table<string, any>
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      -- default astrocommunity config sets this to a path which i dont use
      dir = vim.NIL,
      workspaces = {
        {
          name = "personal",
          path = "~/notes",
        },
      },
      finder = (astrocore.is_available "snacks.pick" and "snacks.pick")
        or (astrocore.is_available "telescope.nvim" and "telescope.nvim")
        or (astrocore.is_available "fzf-lua" and "fzf-lua")
        or (astrocore.is_available "mini.pick" and "mini.pick"),

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      notes_subdir = "notes",
      new_notes_location = "notes_subdir",
      daily_notes = {
        folder = "notes/dailies",
      },
      ---@type obsidian.config.CompletionOpts | table<string, any>
      completion = {
        min_chars = 1,
        nvim_cmp = astrocore.is_available "nvim-cmp",
        blink = astrocore.is_available "blink",
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

      use_advanced_uri = true,
      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = vim.ui.open,
    })
  end,
}
