require('lz.n').load {
	'registers.nvim',
	keys = {
		{ '"', mode = { "n", "x" }},
		{ "<C-r>", mode = "i" },
	},
	cmd = "Registers",
	after = function()
		require'registers'.setup {
			window = {
				border = "double",
				transparency = 10,
			},
		}
	end,
}
