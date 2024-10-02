local gen_ai_spec = require('mini.extra').gen_ai_spec



require('mini.ai').setup {
	custom_textobjects = {
		B = gen_ai_spec.buffer(),
		D = gen_ai_spec.diagnostic(),
		I = gen_ai_spec.indent(),
		L = gen_ai_spec.line(),
		N = gen_ai_spec.number(),
	}
}
--- Keymaps
local legend = {
	keymaps = {
		{"a?, i?", description = "Around/Inside user selected 2 character" },
		{"af, if", description = "Around/Inside function call" },
		{"aa, ia", description = "Around/Inside function argument call" },
	},
}
_G.LEGEND_append(legend)
