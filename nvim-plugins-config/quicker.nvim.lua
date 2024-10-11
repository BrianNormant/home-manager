vim.api.nvim_create_autocmd({"QuickFixCmdPre"}, {
	group = "Lazy",
	pattern = "*",
	callback = function()
		require('quicker').setup {}
	end,
})
