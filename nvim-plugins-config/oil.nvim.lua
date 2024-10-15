require('lze').load {
	'oil.nvim',
	keys = {
		{"<Space>oO", '<cmd>Oil<cr>',          desc = "Open Oil in current window" },
		{"<Space>oo", '<cmd>Oil --float<cr>',  desc = "Open Oil in floating window" },
	},
	after = function ()
		require('oil').setup {
			skip_confirm_for_simple_edits = true,
		}
	end
}

_G.wk.append({
	{"<leader>o",  icon = '', group = "Oil"},
	{"<leader>oo", icon = '', desc = "Open oil float"},
	{"<leader>oO", icon = '', desc = "Open oil in window"},
})
