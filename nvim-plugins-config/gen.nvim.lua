require('lze').load {
	'gen.nvim',
	keys = {
		{"<F1>", "<cmd>Gen<cr>", desc="AI plugin", mode = { "n", "v" }},
	},
	cmd = "Gen",
	after = function ()
		require 'gen'.setup({
			model = 'llama3:latest',
			display_mode = 'split',
			show_prompt = true,
			show_model = true,
		})
	end
}
