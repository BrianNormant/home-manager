require('lze').load {
	'rest.nvim',
	ft = "http",
	after = function ()
		require 'rest-nvim'.setup {}
	end,
}
