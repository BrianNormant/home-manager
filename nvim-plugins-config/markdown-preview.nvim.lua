local lazyload = function ()
	vim.g.mkdp_preview_options = {
		uml = { server = "http://localhost:4578/plantuml", imageFormat = 'svg' },
	}
	vim.g.mkdp_theme = 'light'
end

vim.api.nvim_create_autocmd({"BufNew"}, {
	group = "Lazy",
	pattern = "*.md",
	callback = lazyload,
})
