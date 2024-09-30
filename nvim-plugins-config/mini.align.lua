require('mini.align').setup {}

--- Keymaps
local legend = {
	keymaps = {
		{ "ga", mode = {'n', 'v'}, description = "Start mini-align" },
		{ "gA", mode = {'n', 'v'}, description = "Start mini-align with preview" },
	},
}
_G.LEGEND_append(legend)
