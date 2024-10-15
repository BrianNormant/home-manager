require('lze').load {
	'overseer.nvim',
	dep_of = "compiler.nvim",
	event = "ExitPre",
}
require('lze').load {
	'compiler.nvim',
	keys = {
		{"<F5>",  "<cmd>CompilerOpen<cr>"},
		{"<F17>", "<cmd>CompilerRedo<cr>"},
		{"<F6>",  "<cmd>CompilerToggleResult<cr>"},
	},
	after = function ()
		require('overseer').setup {}
		require('compiler').setup {}
	end
}
