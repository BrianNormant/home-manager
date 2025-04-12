require('lz.n').load {
	{
		'boole.nvim',
		event = "DeferredUIEnter",
		after = function ()
			require 'boole'.setup {
				mappings = {
					increment = '<C-a>',
					decrement = '<C-x>',
				},
			}
		end
	}
}
