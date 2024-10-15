require('lze').load {
	'mini.move',
	keys = {
		{"<M-h>", mode = {"n", "x"} },
		{"<M-j>", mode = {"n", "x"} },
		{"<M-k>", mode = {"n", "x"} },
		{"<M-l>", mode = {"n", "x"} },
	},
	after = function()
		require('mini.move').setup {}
	end
}
