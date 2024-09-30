--- Keymaps
local legend = {
	keymaps = {
		{ "g=", description = "mini-operators evaluate" },
		{ "ss", description = "mini-operators exchange" },
		{ "gm", description = "mini-operators multiply" },
		{ "gr", mode = {"v"}, description = "mini-operators replace with register" },
		{ "sx", description = "mini-operators sort text" },
	},
}
_G.LEGEND_append(legend)

require('mini.operators').setup {
	sort     = { prefix = legend.keymaps[5][1] },
	exchange = { prefix = legend.keymaps[2][1] },
}
