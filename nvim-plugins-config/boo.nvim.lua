require("boo").setup {}

--- Keymaps
local legend = {
	keymaps = {
		{"gi", function() require('boo').boo() end, description="open LSP info"},
		{"<C-s>", "<cmd>ISwap<cr>",           description="Write and save" },
	},
}
_G.LEGEND_append(legend)
