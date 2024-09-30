require('mini.indentscope').setup {
    draw = { animation = require('mini.indentscope').gen_animation.none(), },
}

--- Keymaps
local legend = {
	keymaps = {
		{ "[i", description = "goto indentscope top" },
		{ "]i", description = "goto indentscope bottom" },
	},
}
_G.LEGEND_append(legend)
