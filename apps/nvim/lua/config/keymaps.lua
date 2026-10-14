-- Keymaps are automatically loaded on the VeryLazy event.
-- Default keymaps that are always set:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here.

local map = vim.keymap.set

-- Yank to the end of the line, like `D` and `C` do with change/delete.
map("n", "Y", "y$", { desc = "Yank to End of Line" })

-- Keep the cursor centered when paging with Ctrl-D / Ctrl-U.
map("n", "<C-d>", "<C-d>zz", { desc = "Page Down and Center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page Up and Center" })

-- Resume last session/quicksession from anywhere (LazyVim quicksave is `<leader>qs`).
map("n", "<leader>qs", "<cmd>lua require('persistence').load()<cr>", { desc = "Restore Session" })