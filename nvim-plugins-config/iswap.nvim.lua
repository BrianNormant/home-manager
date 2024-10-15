require('lze').load {
	'iswap.nvim',
	keys = {{'<C-s>', "<cmd>ISwap<cr>", desc = "Swap 2 nodes"}},
	after = function () require('iswap').setup {} end
}
