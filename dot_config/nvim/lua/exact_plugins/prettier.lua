-- Conditional formatting: biome when available, otherwise prettierd
---@type LazySpec
return {
  -- Override conform.nvim to conditionally select biome or prettierd
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.formatters_by_ft then opts.formatters_by_ft = {} end

      ---@param bufnr integer
      ---@return string[]
      local function biome_or_prettier(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname ~= "" and vim.fs.root(bufname, { "biome.json", "biome.jsonc" }) then return { "biome" } end
        return { "prettierd", "prettier", stop_after_first = true }
      end

      -- Filetypes supported by both biome and prettier
      for _, ft in ipairs {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "jsonc",
        "css",
        "graphql",
        "svelte",
        "astro",
        "vue",
      } do
        opts.formatters_by_ft[ft] = biome_or_prettier
      end
    end,
  },
  -- Icons for prettier config files
  {
    "echasnovski/mini.icons",
    optional = true,
    opts = function(_, opts)
      if not opts.file then opts.file = {} end
      for _, filename in ipairs {
        ".prettierrc",
        ".prettierrc.cjs",
        ".prettierrc.js",
        ".prettierrc.json",
        ".prettierrc.mjs",
        ".prettierrc.toml",
        ".prettierrc.yaml",
        ".prettierrc.yml",
        "prettier.config.cjs",
        "prettier.config.js",
        "prettier.config.mjs",
        "prettier.config.ts",
      } do
        opts.file[filename] = { glyph = "", hl = "MiniIconsPurple" }
      end
    end,
  },
}
