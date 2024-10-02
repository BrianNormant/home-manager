--- Keymaps
local legend = {
	keymaps = {
		[1] = { "g=", description = "mini-operators evaluate" },
		[2] = { "gm", description = "mini-operators multiply" },
		[3] = { "ss", description = "mini-operators exchange" },
		[4] = { "sp", description = "mini-operators replace with register" },
		[5] = { "sx", description = "mini-operators sort text" },
	},
}
_G.LEGEND_append(legend)

require('mini.operators').setup {
	sort     = { prefix = legend.keymaps[5][1] },
	exchange = { prefix = legend.keymaps[3][1] },
	replace  = { prefix = legend.keymaps[4][1] },
}
