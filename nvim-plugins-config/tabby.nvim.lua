require('lze').load {
	"tabby.nvim",
	event = "DeferredUIEnter",
	after = function()
		require('tabby').setup {
			preset = "active_wins_at_tail",
			option = {
				lualine_theme = 'gruvbox-material',
				nerdfont = true,
			},
		}
	end
}

-- Keymaps
local legend = {
	keymaps = {
		--- Tabby
		{"<leader>ta",  "<cmd>$tabnew<CR>",           description = "Open new tab"},
		{"<M-t>",       "<cmd>Tabby jump_to_tab<CR>", description = "Use tabby leap feature to jump to a tab via 1 character"},
		{"<leader>tq",  "<cmd>tabclose<CR>",          description = "Close current tab"},
		{"<leader>tQ",  "<cmd>tabonly<CR>",           description = "Close all other tab"},
		-- move current tab to previous position
		{"<leader>tmp", ":-tabmove<CR>",              description = "Move current tab left <-- "},
		-- move current tab to next position
		{"<leader>tmn", ":+tabmove<CR>",              description = "move current tab right -->"},
	},
}

for i = 1, 9 do
	legend.keymaps[#legend.keymaps+1] = {
		"<A-" .. i .. ">", "<cmd>" .. i .. "tabnext<CR>",
		description = "Open tab at index " .. i
	}
end

_G.legendary.append(legend)
