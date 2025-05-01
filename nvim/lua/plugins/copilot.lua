---@type LazySpec
return {
  "zbirenbaum/copilot.lua",
  enabled = false,
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
}
