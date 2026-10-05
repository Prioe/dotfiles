---@type LazySpec
return {
  "jalvesaq/zotcite",
  cond = vim.uv.fs_access(
    vim.env.APPDATA and vim.env.APPDATA .. "/Zotero/Zotero/profiles.ini"
      or vim.fn.expand("~/.zotero/zotero/profiles.ini"),
    "r"
  ) or vim.uv.fs_access(vim.fn.expand("~/Library/Application Support/Zotero/profiles.ini"), "r") or false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<leader>z"] = { desc = " Zotero" },
            ["gx"] = { "<Plug>ZOpenAttachment", desc = "Open attachment (Zotero)" },
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
