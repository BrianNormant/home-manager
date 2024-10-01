require("ts-node-action").setup {}
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- nix
		null_ls.builtins.code_actions.statix,
		null_ls.builtins.diagnostics.statix,

		-- Generic
		null_ls.builtins.completion.spell,

		-- Java
		--
		null_ls.builtins.diagnostics.checkstyle.with {
			extra_args = { "-c", vim.env.HOME .. "/.java/checkstyle/checkstyle.xml" },
		},

		-- C/C++
		null_ls.builtins.diagnostics.cppcheck,

		-- Elixix
		null_ls.builtins.diagnostics.credo,
	},
})
