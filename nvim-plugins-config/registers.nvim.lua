vim.api.nvim_create_autocmd({"UIEnter"}, {
	group = "Lazy",
	pattern = "*",
	callback = function()
		require'registers'.setup {
			window = {
				border = "double",
				transparency = 0,
			},
		}
	end,
})
