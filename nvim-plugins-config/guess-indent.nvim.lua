require('lze').load {
	'guess-indent.nvim',
	event = "BufNew",
	cmd = "GuessIndent",
	after = function ()
		require('guess-indent').setup {
			filetype_exclude = {
				"netrw",
				"tutor",
				"help",
				"man",
				"oil",
			},
		}
	end
}
