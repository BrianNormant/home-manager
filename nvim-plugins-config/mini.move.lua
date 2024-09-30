require('mini.move').setup {}
--- Keymaps
local legend = {
	keymaps = {
		{ "<M-h>", mode = 'v', description = "left" },
		{ "<M-l>", mode = 'v', description = "right" },
		{ "<M-j>", mode = 'v', description = "down" },
		{ "<M-k>", mode = 'v', description = "up" },
		{ "<M-h>", mode = 'n', description = "line_left" },
		{ "<M-l>", mode = 'n', description = "line_right" },
		{ "<M-j>", mode = 'n', description = "line_down" },
		{ "<M-k>", mode = 'n', description = "line_up" },

	},
}
_G.LEGEND_append(legend)

