return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      restore_session = {
        {
          event = "VimEnter",
          desc = "Restore previous directory session if neovim opened with no arguments",
          callback = function()
            if vim.fn.argc(-1) == 0 then
              require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
              -- trigger buffer read auto commands on each opened buffer after load
              vim.tbl_map(vim.cmd.doautoall, { "BufReadPre", "BufReadPost" })
            end
          end,
        },
      },
    },
  },
}
