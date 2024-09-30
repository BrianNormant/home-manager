require('gitsigns').setup {}

--- Keymaps
local legend = {
	keymaps = {
		{"<leader>ub", require('gitsigns').toggle_current_line_blame, description = "Show git blame"},
	},
}
_G.LEGEND_append(legend)
