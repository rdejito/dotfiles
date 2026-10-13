-- Autocmds are automatically loaded on the VeryLazy event.
-- Default autocmds that are always set:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here.

-- Briefly highlight the text you just yanked/pasted.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})