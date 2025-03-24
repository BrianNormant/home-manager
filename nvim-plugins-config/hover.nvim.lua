require("lze").load {
	'hover.nvim',
	event = 'BufEnter',
	after = function ()
		local hover = require('hover')
		hover.setup {
			init = function ()
				require('hover.providers.lsp')
				require('hover.providers.dap')
				require('hover.providers.diagnostic')
				require('hover.providers.man')
				require('hover.providers.dictionary')
				-- gh is avaible if needs be for github issues tracking
			end
		}
	end
}
