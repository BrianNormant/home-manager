require("ts-node-action").setup {}
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- git
		null_ls.builtins.code_actions.gitsigns,

		-- nix
		null_ls.builtins.code_actions.statix,
		null_ls.builtins.diagnostics.statix,

		-- treesiter
		null_ls.builtins.code_actions.ts_node_action,

		-- Generic
		null_ls.builtins.completion.spell,

		-- Java
		null_ls.builtins.diagnostics.checkstyle.with({
        extra_args = { "-c", "/google_checks.xml" }, -- or "/sun_checks.xml" or path to self written rules
		}),

		-- C/C++
		null_ls.builtins.diagnostics.cppcheck,

		-- Elixix
		null_ls.builtins.diagnostics.credo,
	},
})
