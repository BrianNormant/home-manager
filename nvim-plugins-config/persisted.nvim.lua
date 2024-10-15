require('lze').load {
	'persisted.nvim',
	keys = {
		{ "<Space>ss", "<cmd>SessionLoadLast<cr>" },
	},
	after = function()
		require("persisted").setup { autoload = false, }
		require('telescope').load_extension('persisted')
	end
}
