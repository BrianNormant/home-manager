-- Must be loaded after mini a i to override ; mapping
-- Could cause issue, maybe load after mini a i
require('lze').load {
	'nvim-treesitter.textsubjects',
	keys = {
		{ "." ,  mode =  {"x", "o"} },
		-- { ";" ,  mode =  {"x", "o"} },
		-- { "i;" , mode =  {"x", "o"} },
	},
	after = function ()
		require('nvim-treesitter.configs').setup {
			textsubjects = {
				enable = true,
				keymaps = {
					['.'] = 'textsubjects-smart',
					-- [';'] = 'textsubjects-container-outer',
					-- ['i;'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
				},
			},
		}
	end
}
