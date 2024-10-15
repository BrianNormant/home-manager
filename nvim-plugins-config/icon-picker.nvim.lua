require('lze').load {
	'icon-picker.nvim',
	keys = {
		{"<C-e>", "<cmd>IconPickerInsert<cr>", mode="i"},
		{"<C-e>", "<cmd>IconPickerNormal<cr>", mode="n"},
	},
	after = function()
		require('icon-picker').setup {
			disable_legacy_commands = true,
		}
	end
}
