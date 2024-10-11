vim.api.nvim_create_autocmd({"BufNew"}, {
	group = "Lazy",
	pattern = "*.http",
	callback = function ()
		require 'rest-nvim'.setup {}
	end,
})
