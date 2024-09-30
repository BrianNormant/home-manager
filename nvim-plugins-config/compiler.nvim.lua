require('overseer').setup {}
require('compiler').setup {}

--- Keybinds
local legend = {
	keymaps = {
		{"<F5>", "<cmd>CompilerOpen<cr>",          description = "Open compiler view"},
		{"<F6>", "<cmd>CompilerToggleResults<cr>", description = "Toggle compiler result window"},
	},
}
_G.LEGEND_append(legend)
