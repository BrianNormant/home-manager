require('mini.ai').setup { }

--- Keymaps
local legend = {
	keymaps = {
		{"a?, i?", description = "Around/Inside user selected 2 character" },
		{"af, if", description = "Around/Inside function call" },
		{"aa, ia", description = "Around/Inside function argument call" },
	},
}
_G.LEGEND_append(legend)
