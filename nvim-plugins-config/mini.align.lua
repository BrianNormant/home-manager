require('lze').load {
	'mini.align',
	keys = {
		{'ga', mode = {'n', 'x'}, desc = "Align text"},
		{'gA', mode = {'n', 'x'}, desc = "Align text interactive" },
	},
	after = function()
		require('mini.align').setup {}
	end,
}
