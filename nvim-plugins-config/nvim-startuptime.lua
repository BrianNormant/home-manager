vim.api.nvim_create_autocmd({"VimLeavePre"}, {
	pattern = "*",
	command = "!rm /tmp/nvim-startuptime",
})
