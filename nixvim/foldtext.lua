require('lz.n').load {
	'foldtest.nvim',
	event = "DeferredUIEnter",
	after = function ()
		require('foldtest').setup {}
	end
}
