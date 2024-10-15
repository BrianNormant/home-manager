require('lze').load {
	'none-ls.nvim',
	ft = {
		"nix",
		"c",
		"elixir",
	},
	after = function ()
		local null_ls = require('null-ls')
		null_ls.setup({
			sources = {
				-- nix
				null_ls.builtins.code_actions.statix,
				null_ls.builtins.diagnostics.statix,

				-- C/C++
				null_ls.builtins.diagnostics.cppcheck,

				-- Elixir
				null_ls.builtins.diagnostics.credo,
			},
		})
	end
}
