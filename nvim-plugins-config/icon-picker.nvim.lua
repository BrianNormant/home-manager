require('icon-picker').setup {
	disable_legacy_commands = true,
}

--- Keymaps
local legend = {
	keymaps = {
		{"<C-e>", "<cmd>IconPickerInsert<cr>", mode="i", description="Icon Picker insert"},
		{"<C-e>", "<cmd>IconPickerNormal<cr>", mode="n", description="Icon Picker normal"},
	},
}
_G.LEGEND_append(legend)
