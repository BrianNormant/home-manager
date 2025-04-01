require('lz.n').load {
	'foldtext.nvim',
	event = "DeferredUIEnter",
	after = function ()
		require('foldtext').setup {}
	end
}
