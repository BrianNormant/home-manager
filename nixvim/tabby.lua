require('lz.n').load {
	'tabby.nvim',
	event = "DeferredUIEnter",
	after = function()
		require('tabby').setup {
			preset = "active_wins_at_tail",
			option = {
				lualine_theme = _G.get_lualine_name(),
				nerdfont = true,
			},
		}
	end
}
