
-- Functions
local function listAllMarkedFiles()
    local marked_files = vim.api.nvim_eval('netrw#Expose("netrwmarkfilelist")')
    local allMarksString = ""

    print(marked_files);
    if type(marked_files) == "table" and not vim.tbl_isempty(marked_files) then
        for i, file in ipairs(marked_files) do
            allMarksString = allMarksString .. file .. "\n"
        end

        print(allMarksString)
    else
        print("No files are marked!")
    end
end

local function copyToClipboard()
    vim.cmd('normal! "+y')
    print("Yanked to the system clipboard.")
end

-- Yank shitters
vim.keymap.set("v", "<leader>y", function() copyToClipboard() end, { desc = "Copy selection to system clipboard" })

-- General stuffs
vim.keymap.set("n", "<leader>f", ':Ex<CR>', { desc = "Open netrw using leader" })
vim.keymap.set("n", "<leader>ml", listAllMarkedFiles, { desc = "List all marked files" })
vim.keymap.set("n", "<leader>b", ':Telescope buffers<CR>', { desc = "Go to buffer list ong" })
vim.keymap.set("n", "<leader>lg", ':Telescope live_grep<CR>', { desc = "Open telescope with live grep" })
vim.keymap.set("n", "<M-j>", ':cnext<CR>', { desc = "Go next in quickfix list" })
vim.keymap.set("n", "<M-k>", ':cprev<CR>', { desc = "Go prev in quickfix list" })

-- Debugging stuffs
-- Diagnose command for syntax errors
vim.api.nvim_create_user_command('Diagnose', function(opts)
    if opts.fargs[1] == "list" then
        vim.diagnostic.setqflist()
        print("Opening diagnostic list!")
    else
        vim.diagnostic.open_float()
        print("Diagnostic float opened!")
    end
end, {
    nargs = '*',
    complete = function()
        return { "list" }
    end
})

-- My extra vim commands
vim.api.nvim_create_user_command('MarkedFiles', function()
        listAllMarkedFiles()
    end
, {})
