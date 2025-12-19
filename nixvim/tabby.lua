require('lz.n').load {
	'tabby.nvim',
	event = "DeferredUIEnter",
	after = function()
		require('tabby').setup {
			preset = "tab_only",
			option = {
				lualine_theme = _G.get_lualine_name(),
				nerdfont = true,
			},
		}
	end
}
