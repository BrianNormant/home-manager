require 'gen'.setup({
	model = 'llama3:latest',
	display_mode = 'split',
	show_prompt = true,
	show_model = true,
})

--- Keymaps
local legend = {
	keymaps = {
		{"<F1>",  "<cmd>Gen<cr>",  mode="n", description="Open Generative AI"},
		{"<F1>",  ":'<,'>Gen<cr>", mode="v", description="Open Generative AI with range"},
	},
}
_G.LEGEND_append(legend)
