local miniclue = require('mini.clue')
miniclue.setup {
	triggers = {
		-- Leader triggers
		{ mode = 'n', keys = '<Space>' },
		{ mode = 'x', keys = '<Space>' },

		-- default operators
		{ mode = 'n', keys = 'd' },
		{ mode = 'n', keys = 'y' },
		{ mode = 'n', keys = 'c' },

		-- `g` key
		{ mode = 'n', keys = 'g' },
		{ mode = 'x', keys = 'g' },

		-- Marks
		{ mode = 'n', keys = "'" },
		{ mode = 'n', keys = '`' },
		{ mode = 'x', keys = "'" },
		{ mode = 'x', keys = '`' },
		{ mode = "n", keys = 'm' },

		-- Window commands
		{ mode = 'n', keys = '<C-w>' },

		-- `z` key
		{ mode = 'n', keys = 'z' },
		{ mode = 'x', keys = 'z' },

		-- mini.bracketed
		{ mode = 'n', keys = '[' },
		{ mode = 'n', keys = ']' },

		-- mini.surround
		{ mode = "n", keys = 's' },
		{ mode = "v", keys = 's' },
	},

	clues = {
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		-- miniclue.gen_clues.registers(), // registers.nvim does that already
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
}
