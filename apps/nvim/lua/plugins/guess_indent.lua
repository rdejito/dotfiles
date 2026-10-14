return {
    {
        "NMAC427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup {}
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    }
}

