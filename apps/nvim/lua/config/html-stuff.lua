-- General variables
local nvimConfigPath = "/home/excalibur/.config/nvim/lua/config/"
local isWrapMode = false

-- Returns the the insides of the html-template txt file
local function getHtmlTemplate()
    local file = io.open(nvimConfigPath .. "html-template.txt", 'r')
    local result = ""

    if file then
        result = file:read('*a')
        file:close()
    else
        print("Can't seem to open or locate the file!")
    end

    return result
end

local function wrapFunctions(wrapping_method)
    if not isWrapMode then return end
    if wrapping_method == 1 then
        vim.cmd([[s//<&><\/&>]])
        vim.cmd("normal! n")
        vim.cmd("noh")
    end

    if wrapping_method == 2 then
        vim.cmd([[s//<&>]])
        vim.cmd("normal! n")
        vim.cmd("noh")
    end
end

-- My vim commands
vim.api.nvim_create_user_command('HtmlStuff', function(opts)
    if opts.fargs[1] == "html-template" then
        vim.fn.setreg('', getHtmlTemplate(), '^V')
        print("The html template code has been yanked to the main registry.")
    end

    if opts.fargs[1] == "wrap-mode" then
        if not isWrapMode then
            isWrapMode = true
            print("HTML wrap mode enabled.")
        else
            isWrapMode = false
            print("HTML wrap mode disabled.")
        end
    end
end, {
    nargs = 1,
    complete = function()
        return { "html-template", "wrap-mode" }
    end
})
vim.keymap.set("n", "<leader>1", function () wrapFunctions(1) end, { desc = "Trigger lsp for hovering definition" })
vim.keymap.set("n", "<leader>2", function () wrapFunctions(2) end, { desc = "Trigger lsp for hovering definition" })
