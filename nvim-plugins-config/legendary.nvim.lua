vim.g.mapleader = " "
local legend = {
	keymaps = {
		--- Basic keymaps
		{"<A-p>", "<cmd>Legendary<cr>",    description="Open Legendary keybind manager" },
		{"\\",    '<cmd>split<cr><C-w>j',  description="Split horizontal" },
		{"|",     '<cmd>vsplit<cr><C-w>l', description="Split vertical" },

		--- Neotest
		--- TODO install neotest
		{"<F7>", function() require("neotest").run.run() end, description="Run with neotest"},
		{"<F8>", function() require("neotest").run.run(vim.fn.extend("%")) end, description="Run with neotest"},

		--- git
		{"<leader>gg", "<cmd>LazyGit<cr>",      description="open lazygit"},

		--- Term
		{"<leader>tt", function() vim.cmd "tab term" end, description="Open terminal in a new tab"},

		---              UI settings
		--- Treesitter
		{"<leader>uh", "<cmd>TSToggle highlight<cr>", description="Toggle treesiter highlight"},
		{"<leader>uu", function()
			if vim.o.background == "dark" then
				vim.o.background = "light"
			else
				vim.o.background = "dark"
			end
		end, description="change vim light/dark mode"},

		--- Switch between light/dark mode
		-- Telescope internal mappings.
	},
	commands = {
		{":SudaWrite",       description="write a file as root"},
		{":SudaRead",        description="Open a file as root"},
	},
}

_G.LEGEND_append(legend)
require('legendary').setup(_G.LEGEND_S)
