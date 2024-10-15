require('lze').load {
	'nvim-treesitter',
	event = "BufNew",
	after = function ()
		require('nvim-treesitter.configs').setup {
			highlight = { enable = true },
		}
	end
}
