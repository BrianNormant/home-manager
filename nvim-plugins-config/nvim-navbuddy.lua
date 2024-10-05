local actions = require('nvim-navbuddy.actions')

require 'nvim-navbuddy'.setup {
	window = {
		border = "single",
		position = {
			col = "0%",
			row = "100%",
		},
		size = {
			height = "33%",
			width = "100%",
		},
	},
	lsp = { auto_attach = true },
	mappings = {
		["<Up>"]    = actions.previous_sibling(),
		["<Down>"]  = actions.next_sibling(),
		-- ["<Right>"] = actions.children(),
		-- ["<Left>"]  = actions.parent(),
	}
}

require('nvim-navic').setup {
	lsp = { auto_attach = true },
}
--- https://www.reddit.com/r/neovim/comments/122g5rb/comment/jdup761/
local goto_parent = function()
	local symbolPath = require("nvim-navic").get_data()
	local parent = symbolPath[#symbolPath - 1]
	if not parent then
		vim.notify("Already at the highest parent.")
		return
	end
	local parentPos = parent.scope.start
	vim.api.nvim_win_set_cursor(0, { parentPos.line, parentPos.character })
end

--- Keymaps
local legend = {
	keymaps = {
		{"<leader>L",  function() require("nvim-navbuddy").open() end, description="Open Navbuddy"},
		{"L",  require('nvim-navbuddy').open, description="Open Navbuddy"},
		{"gpp", goto_parent, description = "Jump to symbol parent" },
	}
}
_G.LEGEND_append(legend)
