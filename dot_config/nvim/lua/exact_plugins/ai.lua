---@type LazySpec
return {
  -- { import = "astrocommunity.completion.avante-nvim" },
  -- { import = "astrocommunity.editing-support.copilotchat-nvim" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  {
    "zbirenbaum/copilot.lua",
    ---@type copilot_config
    opts = {
      suggestion = {
        debounce = 75,
      },
      filetypes = {
        yaml = true,
        markdown = true,
        gitcommit = true,
        gitrebase = true,
        hgcommit = true,
      },
    },
  },
}
