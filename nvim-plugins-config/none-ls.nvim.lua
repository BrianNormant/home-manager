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
		-- null_ls.builtins.code_actions.ts_node_action, -- plugin like ISwap, extange and nvim-treesitter-textsubject replace it already

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
