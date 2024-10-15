-- leap is lazy loaded by default
-- not using the default key map because they conflict with s from mini.surround
vim.keymap.set({'n', 'x', 'o'}, 'x',  '<Plug>(leap-forward)',     { desc = "󱕘 Leap search" })
vim.keymap.set({'n', 'x', 'o'}, 'X',  '<Plug>(leap-backward)',    { desc = "󱕘 Leap search reverse" })
vim.keymap.set('n',             'gs', '<Plug>(leap-from-window)', { desc = "󱕘 Leap search windows" })


require('lze').load {
	"flit.nvim",
	keys = {
		{'f', mode = { 'n', 'v', 'o' }},
		{'F', mode = { 'n', 'v', 'o' }},
		{'t', mode = { 'n', 'v', 'o' }},
		{'T', mode = { 'n', 'v', 'o' }},
	},
	after = function()
		require('flit').setup {
			labeled_modes = "nvo",
		}
	end
}

-- telepath is lazyloaded by default
require('telepath').use_default_mappings()
