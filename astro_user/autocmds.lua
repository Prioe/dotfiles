-- Autoload resession directory on VimEnter
-- https://github.com/AstroNvim/AstroNvim/issues/1939
vim.api.nvim_del_augroup_by_name "alpha_autostart" -- disable alpha auto start
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only load the session if nvim was started with no args
    if vim.fn.argc(-1) == 0 then
      -- Save these to a different directory, so our manual sessions don't get polluted
      require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
    end
  end,
})
