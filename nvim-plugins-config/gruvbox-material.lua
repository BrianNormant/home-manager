require('lze').load {
	"gruvbox-material",
	-- colorscheme = "gruvbox-material",
	event = "DeferredUIEnter",
	dep_of = { "lualine.nvim", "blink-cmp" },
	before = function ()
		vim.g.gruvbox_material_background = 'soft'
		vim.opt.laststatus = 3
	end,
	after = function ()
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function ()
				vim.cmd [[
				hi NormalFloat ctermfg=223 ctermbg=236 guifg=#d4be98 guibg=#32302f
				hi FloatBorder ctermfg=245 ctermbg=236 guifg=#928374 guibg=#32302f
				hi FloatTitle  ctermfg=208 ctermbg=236 guifg=#e78a4e guibg=#32302f cterm=bold
				hi LeapBackdrop guifg=#888888
				hi LeapLabel guifg=#FF0000
				hi clear SpellBad
				hi clear SpellCap
				hi clear SpellRare
				hi clear SpellLocal
				hi! link Search Visual
				hi! link IncSearch ClapSpinner
				hi! link CurSearch ClapSpinner
				]]
			end
		})
		vim.cmd "colorscheme gruvbox-material"
	end
}

