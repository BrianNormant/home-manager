require('lze').load {
	'mini.operators',
	keys = {
		{"g=", mode = { "n", "x" }},
		{"g=="},
		{"g+", "g=$", nowait = true},
		
		{"ss", mode = { "n", "x" }},
		{"sss"},
		{"sS", "ss$", nowait = true},
		
		{"sp", mode = { "n", "x" }},
		{"spp"},
		{"sP", "sp$", nowait = true},
		
		{"sx", mode = { "n", "x" }},
		{"sxx"},
		{"gm", mode = { "n", "x" }},
		{"gmm"},
	},
	after = function()
		require('mini.operators').setup {
			sort     = { prefix = "sx" },
			exchange = { prefix = "ss" },
			replace  = { prefix = "sp" },
		}
	end
}
