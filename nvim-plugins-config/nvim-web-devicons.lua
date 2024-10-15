require('lze').load {
	'nvim-web-devicons',
	event = 'DeferredUIEnter',
	after = function ()
		require("nvim-web-devicons").setup {}
	end,
}
