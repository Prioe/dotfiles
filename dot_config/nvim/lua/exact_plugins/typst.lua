---@type LazySpec
return {
  { import = "astrocommunity.pack.typst" },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    ---@diagnostic disable: missing-fields
    opts = {
      config = {
        tinymist = {
          ---@type _.lspconfig.settings.tinymist.Tinymist
          settings = {
            formatterMode = "typstyle",
            formatterPrintWidth = 120,
            formatterProseWrap = true,
          },
          ---@type vim.lsp.client.on_attach_cb
          on_attach = function(client, bufnr)
            vim.keymap.set(
              "n",
              "<leader>ltp",
              function()
                client:exec_cmd({
                  title = "pin",
                  command = "tinymist.pinMain",
                  arguments = { vim.api.nvim_buf_get_name(0) },
                }, { bufnr = bufnr })
              end,
              { desc = "[T]inymist [P]in", noremap = true }
            )

            vim.keymap.set(
              "n",
              "<leader>ltu",
              function()
                client:exec_cmd({
                  title = "unpin",
                  command = "tinymist.pinMain",
                  arguments = { vim.v.null },
                }, { bufnr = bufnr })
              end,
              { desc = "[T]inymist [U]npin", noremap = true }
            )
          end,
        },
      },
    },
  },
}
