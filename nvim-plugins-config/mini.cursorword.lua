require('lze').load {
	'mini.cursorword',
	event = "BufNew",
	after = function()
		require('mini.cursorword').setup {
			delay = 1000,
		}
		vim.cmd [[
		hi MiniCursorword gui='underline'
		hi MiniCursorwordCurrent gui='underline'
		]]
	end
}

