---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  ---@diagnostic disable: missing-fields
  opts = {
    config = {
      jsonls = {
        -- same on_new_config workaround as yaml.lua
        before_init = function(_, config)
          config.settings.json.schemas =
            vim.list_extend(config.settings.json.schemas or {}, require("schemastore").json.schemas())
        end,
      },
    },
  },
}
