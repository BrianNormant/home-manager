require('lze').load {
	'muren.nvim',
	keys = {
		{"<F3>", "<cmd>MurenToggle<cr>", mode = { "n", "x" }, desc = "Open Muren"},
	},
	after = function ()
		require('muren').setup {
			all_on_line = false,
			patterns_width = 75,
			patterns_height = 10,
			options_width = 25,
			preview_height = 12,
			anchor = "top",
		}
	end,
}
