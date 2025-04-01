require('lz.n').load {
	keys = {
		{"<C-a>", mode = { "v", "n"}},
		{"<C-x>", mode = { "v", "n"}},
	},
	after = function ()
		require 'boole'.setup {
			mappings = {
				increment = '<C-a>',
				decrement = '<C-x>',
			},
			additions = {
				{ "red", "green", "blue" },
				{ "RED", "GREEN", "BLUE" },
				{ "Red", "Green", "Blue" },
				{ "black", "white" },
				{ "BLACK", "WHITE" },
				{ "Black", "White" },
			}
		}
	end
}
