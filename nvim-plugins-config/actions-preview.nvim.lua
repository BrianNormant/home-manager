require('actions-preview').setup {
	highlight_command = {
		require("actions-preview.highlight").delta(),
	},
	backend = { "telescope" },
}



--- Keybinds
local legend = {
	keymaps = {
		{"<leader>la", require('actions-preview').code_actions, description="LSP view avalaible code actions"},
	}
}

_G.LEGEND_append(legend)
