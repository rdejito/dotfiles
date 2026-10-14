-- Options are automatically loaded before lazy.nvim startup.
--
-- LazyVim already ships with a strong, opinionated set of defaults.
-- Only add your own tweaks / overrides in here.
-- The full list of defaults lives at:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Keep a bit more breathing room around the cursor (LazyVim default: 4).
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Undo persistence is already enabled by LazyVim (`undofile`), so swap files
-- are redundant. Disabling them avoids the "swap file already exists" prompts.
opt.swapfile = false

-- Rounded borders for built-in floating windows (Neovim >= 0.11).
opt.winborder = "rounded"

-- `number` / `relativenumber` are both on by default in LazyVim. Toggle the
-- relative part of the ruler at runtime with `<leader>uL`.
