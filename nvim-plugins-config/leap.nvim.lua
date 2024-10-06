vim.cmd [[
hi LeapBackdrop guifg=#888888
hi LeapLabel guifg=#FF0000
]]
require('flit').setup {}

--- Keymaps
local legend = {
	keymaps = {
		{ 'x',  '<Plug>(leap-forward)',     mode = {'n', 'x', 'o'}, description="Leap search forward" },
		{ 'X',  '<Plug>(leap-backward)',    mode = {'n', 'x', 'o'}, description="Leap search backward" },
		{ 'gs', '<Plug>(leap-from-window)', mode = {'n', 'x', 'o'}, description="Leap search in other windows" },
	},
}
_G.LEGEND_append(legend)
