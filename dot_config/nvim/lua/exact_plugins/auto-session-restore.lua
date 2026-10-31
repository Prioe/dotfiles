-- Restore the directory session when nvim starts without arguments.
--
-- Replaces astrocommunity.recipes.auto-session-restore: when no session exists, that recipe calls
-- `Snacks.dashboard()` without a target window, which opens the dashboard as a full-screen *floating*
-- window. Floats are not replaced when neo-tree (or anything else) opens a split, so the dashboard stays
-- on top until a session exists. Snacks already opens its dashboard in the main window on UIEnter (after
-- VimEnter) whenever the startup buffer is still empty, so no fallback is needed here.
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      restore_session = {
        {
          event = "VimEnter",
          desc = "Restore previous directory session if neovim opened with no arguments",
          nested = true, -- trigger other autocommands as buffers open
          callback = function()
            if vim.fn.argc(-1) > 0 or vim.api.nvim_buf_get_name(0) ~= "" or vim.bo.modified then return end
            for _, arg in ipairs(vim.v.argv) do
              if arg == "-b" or arg == "-c" or arg == "-S" or vim.startswith(arg, "+") then return end
            end
            require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
          end,
        },
      },
    },
  },
}
