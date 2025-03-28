require('lze').load {
	'gen.nvim',
	keys = {
		{"<F1>", "<cmd>Gen<cr>", desc="AI plugin", mode = { "n", "v" }},
	},
	cmd = "Gen",
	after = function ()
		require 'gen'.setup({
			model = 'gemma3:27b',
			display_mode = 'float',
			show_prompt = true,
			show_model = true,
			host = "ollama.ggkbrian.com",
			port = 80,
		})
	end
}
