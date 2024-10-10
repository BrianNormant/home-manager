vim.cmd [[
hi LeapBackdrop guifg=#888888
hi LeapLabel guifg=#FF0000
]]

require('flit').setup {
	labeled_modes = "nvo",
}

--- Keymaps
local legend = {
	keymaps = {
		{ 'x',  '<Plug>(leap-forward)',     mode = {'n', 'x', 'o'}, description="󱕘 Leap search" },
		{ 'X',  '<Plug>(leap-backward)',    mode = {'n', 'x', 'o'}, description="󱕘 Leap search reverse" },
		{ 'gs', '<Plug>(leap-from-window)', mode = {'n', 'x', 'o'}, description="󱕘 Leap search windows" },
	},
}
_G.LEGEND_append(legend)
