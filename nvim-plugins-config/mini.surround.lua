require('lze').load {
	'mini.surround',
	keys = {
		{ "sa", mode = { "n", "x" }},
		{ "sA", "sa$", remap = true },
		{ "sr" },
		{ "sd" },
		{ "sh" },
		{ "sf" },
		{ "sF" },
	},
	after = function ()
		require('mini.surround').setup { }
	end
}
