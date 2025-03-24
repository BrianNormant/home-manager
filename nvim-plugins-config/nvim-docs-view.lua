require('lze').load {
	'nvim-docs-view',
	event = 'LSPAttach',
	after = function ()
		require('docs-view').setup {
			position = "bottom",
		}
		vim.cmd "DocsViewToggle"
	end
}
