require('lze').load {
	'docs-view',
	event = 'LSPAttach',
	after = function ()
		require('docs-view').setup {
			position = "bottom",
		}
	end
}
