vim.api.nvim_create_autocmd({"UIEnter"}, {
	group = "Lazy",
	pattern = "*",
	callback = function()
		require('ccc').setup {
			highlighter = {
				auto_enable = true,
				lsp = true,
			}
		}
	end,
})
