require("diffview").setup {}

--- Keymaps
local legend = {
	keymaps = {
		--- TODO change this to a function to close the diffview if already open
		{"<leader>gG", "<cmd>DiffviewOpen<cr>", description="use diffview to open file"},
	},
}
_G.LEGEND_append(legend)
