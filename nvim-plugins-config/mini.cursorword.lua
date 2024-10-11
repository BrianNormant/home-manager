vim.api.nvim_create_autocmd({"UIEnter"}, {
	group = "Lazy",
	pattern = "*",
	callback = function()
		require('mini.cursorword').setup()
	end
})

vim.cmd [[
hi MiniCursorword gui='underline'
hi MiniCursorwordCurrent gui='underline'
]]
