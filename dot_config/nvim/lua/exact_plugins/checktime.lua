---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      -- Zellij does not forward FocusGained to the inner program, so extend
      -- AstroNvim's default checktime trigger with events that fire during use.
      checktime = {
        {
          event = { "FocusGained", "TermClose", "TermLeave", "BufEnter", "CursorHold", "CursorHoldI" },
          desc = "Check if buffers changed on focus, buffer enter, or idle",
          callback = function()
            if vim.bo.buftype ~= "nofile" then vim.cmd "checktime" end
          end,
        },
      },
    },
  },
}
