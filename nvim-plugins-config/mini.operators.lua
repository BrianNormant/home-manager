--- Keymaps
local legend = {
	keymaps = {
		{ "g=", description = "mini-operators evaluate" },
		{ "sx", description = "mini-operators exchange" },
		{ "gm", description = "mini-operators multiply" },
		{ "gr", description = "mini-operators replace with register" },
		{ "ss", description = "mini-operators sort text" },
	},
}
_G.LEGEND_append(legend)

require('mini.operators').setup {
	exchange = { prefix = legend.keymaps[2][1] },
	sort     = { prefix = legend.keymaps[5][1] },
}
