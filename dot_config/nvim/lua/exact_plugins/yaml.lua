---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  ---@diagnostic disable: missing-fields
  opts = {
    config = {
      yamlls = {
        settings = {
          yaml = {
            customTags = { "!reference sequence" },
          },
        },
      },
    },
  },
}
