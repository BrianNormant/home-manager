require('lze').load {
	'ccc.nvim',
	event = "BufNew",
	after = function ()
		require('ccc').setup {
			highlighter = {
				auto_enable = true,
				lsp = true,
			}
		}
	end
}
