--- Keymaps
local legend = {
	keymaps = {
		[1] = { "g=", description = "mini-operators evaluate" },
		[2] = { "gm", description = "mini-operators multiply" },
		[3] = { "ss", description = "mini-operators exchange" },
		[4] = { "sp", description = "mini-operators replace with register" },
		[5] = { "sx", description = "mini-operators sort text" },
	},
}
_G.LEGEND_append(legend)

require('mini.operators').setup {
	sort     = { prefix = legend.keymaps[5][1] },
	exchange = { prefix = legend.keymaps[3][1] },
	replace  = { prefix = legend.keymaps[4][1] },
}

vim.api.nvim_set_keymap("n", "sP", legend.keymaps[4][1] .. "$", {nowait = true, desc = "Replace with reg to EOF"}) -- replace to end of line with register
vim.api.nvim_set_keymap("n", "g+", legend.keymaps[1][1] .. "$", {nowait = true, desc = "Evaluate as lua to EOF"}) -- evaluate to end of line with register
vim.api.nvim_set_keymap("n", "sS", legend.keymaps[3][1] .. "$", {nowait = true, desc = "Exchange to EOF"}) -- exchange to end of line with register
vim.api.nvim_set_keymap("n", "gM", legend.keymaps[2][1] .. "$", {nowait = true, desc = "Duplicate to EOF"}) -- duplicate to end of line with register
vim.api.nvim_set_keymap("n", "sX", legend.keymaps[5][1] .. "$", {nowait = true, desc = "Sort to EOF"}) -- sort to end of line with register
