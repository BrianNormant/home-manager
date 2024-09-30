require 'nvim-navbuddy'.setup {
	window = {
		border = "single",
		position = {
			col = "0%",
			row = "100%",
		},
		size = {
			height = "33%",
			width = "100%",
		},
	},
	lsp = { auto_attach = true },
}

--- Keymaps
local legend = {
	keymaps = {
		{"<leader>L",  function() require("nvim-navbuddy").open() end, description="Open Navbuddy"},
	}
}
_G.LEGEND_append(legend)

