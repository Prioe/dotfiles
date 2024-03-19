---@type LazySpec
return {
    "zbirenbaum/copilot.lua",
    ---@type copilot_config
    opts = {
      suggestion = {
        debounce= 75
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
