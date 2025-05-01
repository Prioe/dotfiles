return {
  "AstroNvim/astrolsp",
  optional = true,
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      yamlls = {
        settings = { yaml = {
          customTags = {
            "!reference sequence",
          },
        } },
      },
    },
  },
}
