require('lze').load {
	'mini.surround',
	keys = {
		{ "sa", mode = { "n", "x" }},
		{ "sA", "sa$", remap = true },
		{ "sr" }, { "srn"}, { "srl"},
		{ "sd" }, { "sdn"}, { "sdl"},
		{ "sh" }, { "shn"}, { "shl"},
		{ "sf" }, { "sfn"}, { "sfl"},
		{ "sF" }, { "sFn"}, { "sFl"},
	},
	after = function ()
		require('mini.surround').setup { }
	end
}
