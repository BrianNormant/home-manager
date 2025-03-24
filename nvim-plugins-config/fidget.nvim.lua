require('lze').load {
	'fidget.nvim',
	event = 'BufEnter',
	after = function ()
		require('fidget').setup {

		}
	end
}
