require('which-key').setup {
	preset = "helix",
	plugins = {
		marks = true,
		registers = false,
		spelling = { enabled = false, },
	},
	triggers = {
		{ "<auto>", mode = "nxso" },
		{ "s", mode = "n" },
	}
}
