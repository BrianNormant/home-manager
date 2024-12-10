require('lze').load {
	'nvim-treesitter',
	event = "BufNew",
	after = function ()
		require('nvim-treesitter.configs').setup {
			highlight = { enable = true },
		}
		vim.treesitter.language.register('idris', { 'idris2' })
	end
}
