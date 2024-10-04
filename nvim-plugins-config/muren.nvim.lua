require('muren').setup {
	all_on_line = false,
	patterns_width = 75,
	patterns_height = 10,
	options_width = 25,
	preview_height = 12,
	anchor = "top",
}


--- Key maps
local legend = {
	keymaps = {
		{"<F3>", "<cmd>MurenToggle<cr>",  mode = "n", description="Open Muren"},
		{"<F3>", ":'<,'>MurenToggle<cr>", mode = "v", description="Open Muren with range"}
	},
}
_G.LEGEND_append(legend)

