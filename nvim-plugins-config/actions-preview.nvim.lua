vim.api.nvim_create_autocmd({"LspAttach"}, {
	group = "Lazy",
	pattern = { "*" },
	callback = function()
		require('actions-preview').setup {
			highlight_command = {
				require("actions-preview.highlight").delta(),
			},
			backend = { "telescope" },
		}
	end
})

--- Keybinds
local legend = {
	keymaps = {
		{"<leader>la", function()
			require('actions-preview').code_actions()
		end, description="LSP view avalaible code actions"},
	}
}

_G.LEGEND_append(legend)
