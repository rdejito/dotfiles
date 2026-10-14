-- Force the damn mapleader
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]

require("config.lazy")
require("lazy").setup("plugins")

require("config.html-stuff")
require("config.my-basic-setup")
require("config.lsp-config")
require("config.theme-config")

-- Tab setting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

-- Colorscheme
vim.cmd("colorscheme catppuccin")

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd("set nowrap")
vim.opt.guicursor = "i:block"

-- Plugin setups
local hbac = require("hbac")
hbac.setup({
    autoclose     = true, -- set autoclose to false if you want to close manually
    threshold     = 10, -- hbac will start closing unedited buffers once that number is reached
    close_command = function(bufnr)
    vim.api.nvim_buf_delete(bufnr, {})
    end,
    close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
})

-- Neovide setup
local function setup_neovide()
    -- Global variables configuration
    vim.g.neovide_fullscreen = true
    vim.g.neovide_cursor_animation_length = 0.25
    vim.g.neovide_cursor_smooth_blink = true
    vim.g.neovide_opacity = 0.80
    vim.g.neovide_window_blurred = true
    vim.g.neovide_cursor_vfx_mode = "torpedo"
    vim.g.neovide_cursor_vfx_mode = "wireframe"

    -- Scale factor configurations & safe keymaps
    if vim.g.neovide_scale_factor == nil then
        vim.g.neovide_scale_factor = 1.0
    end

    local change_scale_factor = function(delta)
        local current = vim.g.neovide_scale_factor or 1.0
        local new_scale = current + delta
        if new_scale < 0.1 then new_scale = 0.1 end
        vim.g.neovide_scale_factor = new_scale
    end

    vim.keymap.set({ "n", "v" }, "<C-=>", function() change_scale_factor(0.1) end, { desc = "Increase Neovide Scale" })
    vim.keymap.set({ "n", "v" }, "<C-->", function() change_scale_factor(-0.1) end, { desc = "Decrease Neovide Scale" })
    vim.keymap.set({ "n", "v" }, "<C-0>", function() vim.g.neovide_scale_factor = 1.0 end, { desc = "Reset Neovide Scale" })
    vim.keymap.set({ "n", "v" }, "<C-V>", '+"P', { desc = "Paste clipboard text" })

    -- Cursor and syntax color adjustments
    vim.cmd([[highlight Cursor guibg=#faf200 guifg=black]])
    vim.cmd([[highlight lCursor guibg=#faf200 guifg=black]])
    vim.cmd("set guicursor=n-v-c:block-Cursor,i-ci-ve:ver25-Cursor")

    -- Neovim backgrounds overrides
    vim.cmd([[highlight Normal guibg=#000000]])
    vim.cmd([[highlight StatusLine guibg=#0a0a12]])
    vim.cmd([[highlight TabLineFill guibg=#131324]])
end

-- catch normal startups where Neovide triggers standard initialization
if vim.g.neovide then
    setup_neovide()
end

-- catch headless startups when Neovide attaches *later* via server socket
vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        -- Only run if the newly attached UI client is actually Neovide
        if vim.g.neovide then
            setup_neovide()
            require('cord').setup({})
        end

    end,
})
-- start cord.nvim
local status_ok, cord = pcall(require, 'cord')
if status_ok then
    cord.setup({})
end

-- Highlight on netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.cmd("hi! link netrwMarkFile Search")
  end,
})
