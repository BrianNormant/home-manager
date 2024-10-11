local loaded = false
vim.api.nvim_create_autocmd({"UIEnter"}, {
	group = "Lazy",
	pattern = "*",
	callback = function()
		if loaded then return end
		loaded = true
		require('ccc').setup {
			highlighter = {
				auto_enable = true,
				lsp = true,
			}
		}
	end,
})
