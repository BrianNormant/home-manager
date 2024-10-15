require('lze').load {
	'markdown-preview.nvim',
	cmd = {
		"MarkdownPreview",
		"MarkdownPreviewStop",
		"MarkdownPreviewToggle",
	},
	after = function()
		vim.fn["mkdp#util#install"]()
		vim.g.mkdp_preview_options = {
			uml = { server = "http://localhost:4578/plantuml", imageFormat = 'svg' },
		}
		vim.g.mkdp_theme = 'light'
	end
}
