require('actions-preview').setup {
	highlight_command = {
		require("actions-preview.highlight").delta(),
	},
	backend = { "telescope" },
}



--- Keybinds
local legend = { keymaps = {
	{"<leader>la", function()
		if vim.bo.filetype == "java" then
			vim.lsp.buf.code_action()
		else
			require'actions-preview'.code_actions()
		end
	end, description="LSP view avalaible code actions"},
} }

_G.LEGEND_append(legend)
