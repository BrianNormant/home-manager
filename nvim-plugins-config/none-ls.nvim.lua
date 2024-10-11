local null_ls = require("null-ls")
vim.api.nvim_create_autocmd({"UIEnter"}, {
	group = "Lazy",
	pattern = "*",
	callback = function ()
		null_ls.setup({
			sources = {
				-- nix
				null_ls.builtins.code_actions.statix,
				null_ls.builtins.diagnostics.statix,

				-- C/C++
				null_ls.builtins.diagnostics.cppcheck,

				-- Elixix
				null_ls.builtins.diagnostics.credo,
			},
		})
	end
})
