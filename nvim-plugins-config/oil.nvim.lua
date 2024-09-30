require('oil').setup {
	skip_confirm_for_simple_edits = true,
}

local legend = {
	keymaps = {
		{"<leader>oo", '<cmd>Oil<cr>',          description = "Open Oil in current window" },
		{"<leader>oO", '<cmd>Oil -- float<cr>', description = "Open Oil in floating window" },
	},
}
_G.LEGEND_append(legend)

