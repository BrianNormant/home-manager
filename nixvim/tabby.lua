require('lz.n').load {
	'tabby.nvim',
	event = "DeferredUIEnter",
	after = function()
		require('tabby').setup {
			preset = "active_wins_at_tail",
			option = {
				lualine_theme = 'gruvbox-material',
				nerdfont = true,
			},
		}
	end
}
