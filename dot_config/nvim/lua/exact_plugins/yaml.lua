---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  ---@diagnostic disable: missing-fields
  opts = {
    config = {
      yamlls = {
        -- pack schemastore setup is ignored by vim.lsp.config (astrocommunity#1774, drop once fixed);
        -- mutate settings in place, a replaced config.settings never reaches the server
        before_init = function(_, config)
          config.settings.yaml.schemas =
            vim.tbl_deep_extend("force", config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
        end,
        settings = {
          yaml = {
            customTags = { "!reference sequence" },
          },
        },
      },
    },
  },
}
