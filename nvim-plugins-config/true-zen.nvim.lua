require("true-zen").setup {}

-- Keymaps
local legend = {
	keymaps = {
		{"<leader>zn",  "<cmd>TZNarrow<CR>",       mode  =  "n", description = "TrueZen focus a section of text"},
		{"<leader>zn",  ":'<,'>TZNarrow<CR>",      mode  =  "v", description = "TrueZen focus a section of text"},
		{"<leader>zf",  "<cmd>TZFocus<CR>",        mode  =  "n", description = "TrueZen focus the current buffer"},
		{"<leader>zm",  "<cmd>TZMinimalist<CR>",   mode  =  "n", description = "TrueZen remove all visual cluter"},
		{"<leader>za",  "<cmd>TZAtaraxis<CR>",     mode  =  "n", description = "TrueZen center the curent buffer"},
	},
}
_G.LEGEND_append(legend)
