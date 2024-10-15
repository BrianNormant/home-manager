require('lze').load {
	'actions-preview.nvim',
	keys = {
		{"<space>la", function () require('actions-preview').code_actions() end}
	},
	after = function ()
		require('actions-preview').setup {
			highlight_command = {
				require("actions-preview.highlight").delta(),
			},
			backend = { "telescope" },
		}
	end,
	dep_of = {
		"nvchad-menu",
	}
}
