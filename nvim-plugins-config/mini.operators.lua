--- Keymaps
local legend = {
	keymaps = {
		{ "g=", description = "mini-operators evaluate" },
		{ "gm", description = "mini-operators multiply" },
		{ "ss", description = "mini-operators exchange" },
		{ "sp", description = "mini-operators replace with register" },
		{ "sx", description = "mini-operators sort text" },
	},
}
_G.LEGEND_append(legend)

require('mini.operators').setup {
	sort     = { prefix = legend.keymaps[5][1] },
	exchange = { prefix = legend.keymaps[2][1] },
}
