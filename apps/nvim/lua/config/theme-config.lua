
local catpu = require("catppuccin")
local lualine = require("lualine")
local bufferline = require("bufferline")
local nvim_ver = vim.version();
local nvim_ver_str = string.format("%d.%d.%d", nvim_ver.major, nvim_ver.minor, nvim_ver.patch);

-- Functions
-- Time for displaying my missery
--[[
local function getTime()
    local time = os.date("*t")
    local hour = (time.hour > 12) and (time.hour - 12) or time.hour
    local minute = (time.min < 10) and ("0"..time.min) or time.min
    local mm = (time.hour >= 12) and "PM" or "AM"

    if (hour == 0) then hour = 12 end
    return hour .. ":" .. minute .. " " ..mm
end
]]

-- Catppuccin setup
catpu.setup({
    flavour = "mocha",
    show_end_of_buffer = true,
    -- Transparent type shi
    transparent_background = true,
    --float = { transparent = false }
})

-- setup must be called before loading
-- vim.cmd.colorscheme "catppuccin"


--  
-- Lualine setup
lualine.setup({
    options = {
        icons_enabled = true,
        theme = 'tomorrow_night',
        --component_separators = '',
        --section_separators = { left = '', right = '' },
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        }
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
        refresh_time = 16, -- ~60fps
    },
    events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
    },
    -- 'encoding', 'progress'
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{'filename', path = 1}},
        --lualine_x = { getTime },
        lualine_y = {'fileformat', 'filetype'},
        lualine_z = {'location'}
    },
    --[[tabline = {
        lualine_a = {{
            'tabs', max_length = vim.o.columns, mode = 2, path = 0,
            use_mode_colors = false,
            tabs_color = {
                active = {fg = '#1f2411', bg = '#9bcf00', gui = 'bold'},
                inactive = {fg = '#3d3d3d', bg = '#969696'}
            }
        }}
    },
    --]]
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', color = {fg = '#999999'}}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {},
    extensions = {}
})

vim.opt.termguicolors = true

local uni_indicator = '#758D99'
local uni_fg = '#ffffff'
local uni_bg = '#282c40'
bufferline.setup({
    options = {
        mode = "tabs",
        --numbers = "ordinal",
        indicator = { icon = '█ ' }
    },
    highlights = {
        buffer_selected = {
            fg = uni_fg,
            bg = uni_bg,
            bold = true
        },
        numbers_selected = {
            fg = uni_fg,
            bg = uni_bg,
            bold = true,
        },
        tab_separator = {
            fg = uni_fg,
            bg = uni_bg,
        },
        close_button_selected = {
            fg = uni_fg,
            bg = uni_bg,
        },
        indicator_selected = {
            fg = uni_indicator,
            bg = uni_bg,
        },
        modified_selected = {
            fg = uni_fg,
            bg = uni_bg,
        },
        fill = {
            bg = '#181825',
        },
    }
})

local startup_nvim = require("startup")
local user_theme = require("startup.themes.dashboard")

local death_note_art_1 = {
        "",
        "",
        "",
        "",
        "",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢶⣦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠈⠹⡆⢀⣤⣤⡀⢠⣤⢠⣤⣿⡤⣴⡆⠀⣴⠀⠀⠀⢠⣄⠀⢠⡄⠀⠀⠀⣤⣄⣿⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠰⠆⠀⣷⢸⣧⣀⡀⢸⢹⡆⠀⢸⡇⠠⣧⢤⣿⠀⠀⠀⢸⡟⣦⣸⡇⡞⡙⢣⡀⢠⡇⠀⢿⠋⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⣠⠟⢸⣇⣀⡀⣿⠉⢻⡀⢸⡇⠀⣿⠀⣿⠀⠀⠀⣸⡇⠘⢿⡏⢇⣁⡼⠃⣼⠃⠀⣼⡓⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⡿⠒⠋⠁⠀⠈⠉⠉⠁⠉⠀⠀⠀⠀⠉⠀⠉⠀⠉⠀⠀⠀⠉⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠛⠓⠲⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⣠⣴⣶⣾⣿⣿⣾⣷⣦⣤⣿⣶⣶⣤⣄⣀⢤⡀⠀⠀⠀⠀⢰⣴⣶⣷⣴⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣄⣀⣀⣀⣤⣤⣶⣶⣶⣦⣤⠤",
        "⠠⠔⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⢀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⠟⠛⠛⠂⠀⠀",
        "⠀⠀⠀⠘⠋⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⢻⣿⣿⣿⣿⡏⠀⠀⠀⢀⣤⣾⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠘⠀⡿⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣤⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠼⠛⠟⠋⣿⣿⡿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⠋⠙⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡿⠀⠸⠋⣿⣿⣿⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⣿⣿⣿⠋⠛⠇⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⢀⣿⣿⠁⠀⠈⢻⣿⣿⣿⣿⣿⡿⠋⠈⣿⣿⡏⠃⠀⠘⣿⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡏⠀⠀⠀⠈⣿⣿⣿⣿⣿⠀⠀⠀⠸⣿⣇⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⣼⣿⣿⣿⣿⣿⡄⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠁⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⠆⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣇⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⢠⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣦⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠋⠉⠉⠛⠉⠋⠻⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⣤⣾⣿⣿⣿⣿⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⡇⠙⠀⠀⠀⢸⠋⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⢿⣷⡢⡀⠀⠀⢀⣰⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⠀⠁⠁⠀⠀⠀⠀⠉⢠⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡄⠀⠀⠀⠀⠀⠀⠀⣾⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣇⠀⠀⠀⠀⠀⠀⢸⣿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡿⠀⠀⠀⠀⠀⠀⠘⢿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠃⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}
local death_note_art_2 = {
    "",
    "",
    "",
    "╔════════════════════════════════════════════════════╗",
    "║ ⣲⣤⣾⣿⣿⣿⣿⣿⣿⣆⢸⣿⣧⢻⣷⡹⣿⣿⣿⣷⣬⡛⢿⣿⣿⣿⣿⣷⣮⡻⣿⣿⣿⣿⣿⣷⣮⣛⢿⣿⣿⣶⣭⣛⠶⣭⣛⢿⣷⣿ ║",
    "║ ⣽⡿⢿⣿⣿⣇⢻⣿⣿⣿⣾⣿⣿⣿⣿⣷⣜⢿⣿⣿⢿⣿⣷⣿⡿⣿⣿⣿⡻⣷⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿ ║",
    "║ ⠉⢀⣿⣿⣿⣿⣦⡙⢿⣿⣿⣿⣿⣿⣿⣟⢿⣦⡙⣿⣧⣻⣿⣿⣿⣷⣿⣿⣿⣷⣽⢿⣿⣿⣿⣿⣷⣯⡻⣷⣿⣢⡙⠿⣿⣿⣿⣿⣿⣿ ║",
    "║ ⣤⣾⣿⣿⣿⣿⡏⣿⣦⣌⠙⠻⢿⣿⣿⣿⣿⣿⣿⣮⣙⢿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣾⢿⣿⡣⠀⠘⢿⣿⣿⣿⣿ ║",
    "║ ⣿⣿⣿⣿⣸⣿⣿⣿⣿⣿⣿⣦⣄⡈⠛⠿⣿⣿⣿⣿⣿⣶⣝⢿⣿⣿⣮⣹⡿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣷⡝⢿⣦⠀⠘⣿⣿⣿⣿ ║",
    "║ ⣿⣿⣿⣿⣇⢿⡏⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣭⣻⣿⣿⣿⣿⣿⣿⣿⣿⣝⡻⢷⣭⣛⢷⣝⢿⣿⣿⣿⣿⣿⣿⣿⣦⠻⣷⣄⣾⣿⣿⣿ ║",
    "║ ⣿⣿⣿⣿⣿⡞⣧⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣝⣿⣿⣿⣷⣽⣿⣿⣿⣿⣿⣿⣿⣷⡘⣿⣿⣿⣿⣿ ║",
    "║ ⣿⣻⣿⣿⣿⣿⡈⣿⣿⣿⣿⠙⢿⣿⣿⣿⣯⣻⣿⣿⣿⣿⣿⣿⢿⡛⠿⣿⣟⢿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣷⡌⢿⣿⣿⣿ ║",
    "║ ⡟⣿⣿⣿⣿⣿⣧⠘⣿⣿⣿⣄⣀⣹⣿⣿⣿⣿⣽⣿⣯⣿⣿⣿⣷⣽⣤⡾⢻⣿⣿⣿⡏⠛⢿⣿⣿⣿⣮⡻⣿⣿⣿⣿⣿⣿⣎⢿⣿⣿ ║",
    "║ ⣿⣿⣿⣿⣿⣿⣿⣷⡹⣿⣿⣿⠁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡙⢿⡿⣿⡇⠈⠿⣿⠿⠃⠀⣸⠃⢻⣿⣿⣿⣞⣿⣿⣿⣿⣿⣿⣿⣿⣿ ║",
    "║ ⢸⣿⣿⣿⣿⣿⣿⣷⣷⣽⣿⣿⠀⠹⣿⡿⠈⢿⣟⠛⠿⣿⣿⣷⡄⠉⠚⠳⢤⣀⡀⢀⣠⣾⠏⠀⠘⣿⣿⣿⣿⣷⣽⣿⣿⣯⣿⣿⣿⣿ ║",
    "║ ⣿⣿⠇⢹⣿⣿⣿⣿⡟⣿⣿⣿⢳⣄⣀⣀⣠⡶⠉⡗⠀⠈⠙⠻⣿⣆⠀⠀⠀⠉⠛⠛⠋⠁⠀⠀⠀⣿⢻⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⣿ ║",
    "║ ⣿⣿⣊⠹⣿⡾⣿⣿⣿⣽⣿⣿⣇⠙⠛⠛⠋⠀⢀⡇⠀⠀⠀⠀⠀⠉⠳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ ║",
    "║ ⣿⣿⡟⠀⢻⣧⢿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿ ║",
    "║ ⣿⣿⢃⢀⡀⣿⠀⢻⡏⢻⣿⣿⣿⡌⠀⠀⠀⠘⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠈⣿⣿⡿⣿⡟⢿⣿⣿⣿⣟ ║",
    "║ ⣿⣿⢀⣀⣑⠛⡇⠈⣿⡈⣿⣿⣿⣿⡀⠀⠀⠀⠀⠑⠢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⡇⠸⣿⡀⠈⠻⢿⣿ ║",
    "║ ⢺⣧⡀⢋⠀⡀⠘⣄⢘⣧⡨⣿⣟⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⢸⣿⡇⠀⠙⣧⠀⠀⠀⢻ ║",
    "║ ⢙⣿⡿⠃⠀⠒⠀⠘⠀⠙⣿⣿⣿⢹⣿⣿⣦⡀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⡟⠀⠀⣿⡇⠀⠀⠘⠀⠀⠀⡼ ║",
    "║ ⠠⢿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠘⣿⠀⢿⣿⡇⠱⣄⡀⠀⠀⠙⠠⠤⠤⠤⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠁⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠁ ║",
    "║ ⣔⡟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡇⠈⢿⣿⠀⢹⣿⣦⡀⠀⠰⠤⠤⠖⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⡏⠀⠀⠀⠸⠃⠀⠀⠀⠀⠀⠀⠀ ║",
    "║ ⣬⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠀⠈⢿⡀⠀⠻⠻⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ║",
    "║ ⠀⠈⡱⠀⠀⠀⠀⠀⣄⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠙⣿⠷⣄⡀⠀⢀⣀⡴⠛⠁⠈⢛⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸ ║",
    "║ ⠃⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠘⣇⠀⠉⠉⠉⠁⠀⠀⠀⠀⠀⣿⡏⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⣼ ║",
    "║ ⠀⠋⠀⠀⠈⠀⢀⡴⠀⠀⠀⠀⠐$BANACOUNT⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⢿⡇⠀⠈⠛⢷⣦⡀⠀⠀⠀⠀⠀⠀⠀⣿ ║",
    "║ ⠠⠬⠀⠀⢀⡴⢁⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⢸⣧⠀⠀⠀⡈⢻⡟⠓⠀⠀⠀⠄⠀⠀⠹ ║",
    "╚════════════════════════════════════════════════════╝",
    "by rushhh :3",
    "------------------",
}

local cute_art = {
	"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⢀⡴⣆⠀⠀⠀⠀⠀⣠⡀ ᶻ 𝗓 𐰁 .ᐟ ⣼⣿⡗⠀⠀⠀⠀",
	"⠀⠀⠀⣠⠟⠀⠘⠷⠶⠶⠶⠾⠉⢳⡄⠀⠀⠀⠀⠀⣧⣿⠀⠀⠀⠀⠀",
	"⠀⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣤⣤⣤⣤⣤⣿⢿⣄⠀⠀⠀⠀",
	"⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠙⣷⡴⠶⣦",
	"⠀⠀⢱⡀⠀⠉⠉⠀⠀⠀⠀⠛⠃⠀⢠⡟⠀⠀⠀⢀⣀⣠⣤⠿⠞⠛⠋",
	"⣠⠾⠋⠙⣶⣤⣤⣤⣤⣤⣀⣠⣤⣾⣿⠴⠶⠚⠋⠉⠁⠀⠀⠀⠀⠀⠀",
	"⠛⠒⠛⠉⠉⠀⠀⠀⣴⠟⢃⡴⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	"",
	"by rushhh :3",
	"------------------",
}

local sections = {
    art_contain = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Header",
        margin = 5,
        content = cute_art,
        highlight = "Function",
        default_color = "",
        oldfiles_amount = 0
    },

    version_contain = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Footer",
        margin = 5,
        content = { "NEOVIM VERSION " .. nvim_ver_str },
        highlight = "Function",
        default_color = "",
        oldfiles_amount = 0,
    },

    operation_contain = {
        type = "mapping",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Basic Commands",
        margin = 5,
        content = {
            { "  Find File", "Telescope find_files", "<leader>ff" },
            { "󰍉  Find Word", "Telescope live_grep", "<leader>lg" },
            { "  File Browser", "Telescope file_browser", "<leader>fb" },
            { "  Open 'work.vim'", "source work.vim", "<leader>gg" },
            -- { " Recent Files", "Telescope oldfiles", "<leader>of" },
            --{ " Colorschemes", "Telescope colorscheme", "<leader>cs" },
            --{ " New File", "lua require'startup'.new_file()", "<leader>nf" },
        },
        highlight = "Function",
        default_color = "",
        oldfiles_amount = 0,
    }
}

user_theme.header = sections.version_contain;
user_theme.body =  sections.art_contain;
user_theme.footer = sections.operation_contain;

startup_nvim.setup(user_theme);
