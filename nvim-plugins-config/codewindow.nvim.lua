vim.api.nvim_create_autocmd({"UIEnter"}, {
	group = "Lazy",
	pattern = "*",
	callback = function ()
		require("codewindow").setup {
			auto_enable = true,
			exclude_filetypes = {
				'help', 'oil', 'telescope', 'Navbuddy'
			},
		}
	end
})
