require('lze').load {
	'inc-rename.nvim',
	keys = {
		{ "gR" },
	},
	cmd = "IncRename",
	after = function()
		require('inc_rename').setup {
			input_buffer_type = "dressing",
			cmd_name = "IncRename",
		}
		vim.keymap.set("n", "gR", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { expr = true })
	end
}
