require('lze').load {
	'goto-preview',
	keys = {
		{"gpd", function() require('goto-preview').goto_preview_definition() end,      desc = "LSP preview definition"},
		{"gpt", function() require('goto-preview').goto_preview_type_definition() end, desc = "LSP preview type definition"},
		{"gpi", function() require('goto-preview').goto_preview_implementation() end,  desc = "LSP preview implementation"},
		{"gpD", function() require('goto-preview').goto_preview_declaration() end,     desc = "LSP preview declaration"},
		{"gpr", function() require('goto-preview').goto_preview_references() end,      desc = "LSP preview references"},
		{"gP",  function() require('goto-preview').goto_preview_close() end,           desc = "LSP preview window"},
	},
	after = function()
		local gp = require('goto-preview')
		gp.setup { border = "rounded" }
	end,
	dep_of = {
		'nvchad-menu'
	},
}
