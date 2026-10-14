local languages = {
	"python",
	"css",
	"html",
	"javascript",
	"typescript",
	"java",
	"rust",
	"markdown",
}

return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	config = function ()
		require('nvim-treesitter').install(languages)
		vim.api.nvim_create_autocmd('FileType', {
			pattern = languages,
			callback = function() vim.treesitter.start() end,
		})
	end
}
