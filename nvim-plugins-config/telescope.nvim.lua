local telescope = require "telescope"
telescope.setup {
	defaults = {
		layout_strategy = "flex",
		theme = "ivy",
	},
	extensions = {
		["ui-select"] = {
			theme = "cursor",
		},
	},
}
telescope.load_extension('lsp_handlers')
telescope.load_extension('ui-select')
