require("neodim").setup({
	alpha = 0.5,
	blend_color = "#32302F",
	hide = {
		underline = true,
		virtual_text = true,
		signs = true,
	},
	regex = {
		"[uU]nused",
		"[nN]ever [rR]ead",
		"[nN]ot [rR]ead",
	},
	priority = 128,
	disable = {},
})
