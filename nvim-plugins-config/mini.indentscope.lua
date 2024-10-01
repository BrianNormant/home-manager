require('mini.indentscope').setup {
    draw = {
		delay = 2000,
		animation = require('mini.indentscope').gen_animation.none(),
	},
	indent_at_cursor = false,
	symbol = "",
}

--- Keymaps
local legend = {
	keymaps = {
		{ "[i", description = "goto indentscope top" },
		{ "]i", description = "goto indentscope bottom" },
	},
}
_G.LEGEND_append(legend)
