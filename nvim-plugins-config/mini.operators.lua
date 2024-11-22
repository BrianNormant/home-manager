require('lze').load {
	'mini.operators',
	keys = {
		{"g=", mode = { "n", "x" }},
		{"g+", "g=$", remap = true},
		
		{"ss", mode = { "n", "x" }},
		{"sS", "ss$", remap = true},
		
		{"sp", mode = { "n", "x" }},
		{"sP", "sp$", remap = true},
		
		{"sx", mode = { "n", "x" }},
		{"gm", mode = { "n", "x" }},
	},
	after = function()
		require('mini.operators').setup {
			sort     = { prefix = "sx" },
			exchange = { prefix = "ss" },
			replace  = { prefix = "sp" },
		}
	end
}
