require('mini.surround').setup { }

--- Keymaps
local legend = {
	keymaps = {
		{ "sa", description = "mini-surround add around {textobject} {surround}" },
		{ "sd", description = "mini-surround delete {surround}" },
		{ "sr", description = "mini-surround add around {surround} {surround}" },
		{ "sf", description = "mini-surround find surroundings" },
		{ "sF", description = "mini-surround find surroundings reverse" },
		{ "sh", description = "mini-surround highlight surrounding" },
	},
}
_G.LEGEND_append(legend)

