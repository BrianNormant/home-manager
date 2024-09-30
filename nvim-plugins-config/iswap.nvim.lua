require('iswap').setup { }

--- Keymaps
local legend = {
	keymaps = {
		{"<C-s>", "<cmd>ISwap<cr>", description="Swap 2 treesiter node" },
	},
}
_G.LEGEND_append(legend)

