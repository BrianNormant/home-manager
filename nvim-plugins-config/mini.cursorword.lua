require('lze').load {
	'mini.cursorword',
	event = "BufNew",
	after = function()
		require('mini.cursorword').setup()
		vim.cmd [[
		hi MiniCursorword gui='underline'
		hi MiniCursorwordCurrent gui='underline'
		]]
	end
}

