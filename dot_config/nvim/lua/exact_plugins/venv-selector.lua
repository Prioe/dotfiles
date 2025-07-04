---@type LazySpec
return {
  "linux-cultist/venv-selector.nvim",
  opts = {
    search = {
      -- The defaults of venv-selector.nvim dont include the global uv venvs, this adds them
      -- TODO: either open PR to venv-selector.nvim or astrocommunity to add this
      uv = {
        command = "$FD '/bin/python$' ~/.cache/uv/environments-v2 --no-ignore-vcs --full-path",
      },
    },
  },
}
