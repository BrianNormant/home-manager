require('lz.n').load {
	'foldtext.nvim',
	event = "DeferredUIEnter",
	after = function ()
		require('foldtext').setup {
			ft_ignore = {},
			bt_ignore = {},
			default   = {
				type = "raw",
				condition = function (_)
					return true
				end,
				text = "Fold",
				hl = "Folded",
			},
			custom    = {},
		}
	end
}
