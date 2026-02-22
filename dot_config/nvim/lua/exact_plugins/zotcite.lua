---@type LazySpec
return {
  "jalvesaq/zotcite",
  -- Zotero 8 moved citation keys from better-bibtex.sqlite into the main DB.
  -- Remove this patch once https://github.com/jalvesaq/zotcite handles Zotero 8+ natively.
  build = "git apply " .. vim.fn.stdpath("config") .. "/patches/zotcite-zotero8-citationkeys.patch",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<leader>z"] = { name = " Zotero" },
            ["<leader>zo"] = { "<Plug>ZOpenAttachment", desc = "[O]pen attachment" },
            ["<leader>zi"] = { "<Plug>ZCitationInfo", desc = "Citation [i]nfo" },
            ["<leader>za"] = { "<Plug>ZCitationCompleteInfo", desc = "[A]ll reference fields" },
            ["<leader>zb"] = { "<Plug>ZExtractAbstract", desc = "Insert a[b]stract" },
            ["<leader>zv"] = { "<Plug>ZViewDocument", desc = "[V]iew document" },
          },
          i = {
            ["<C-x><C-b>"] = { "<Plug>ZCite", desc = "Insert citation key" },
          },
        },
      },
    },
  },
  config = function()
    require("zotcite").setup({
      key_type = "better-bibtex",
    })
  end,
}
