require('lz.n').load {
	{
		'goto-preview.nvim',
		event = 'LspAttach',
		after = function ()
			require('goto-preview').setup {
				border = "rounded"
			}
		end
	},
	{
		'actions-preview.nvim',
		event = 'LspAttach',
		after = function ()
			require('actions-preview').setup {
				highlight_command = {
					require("actions-preview.highlight").delta(),
				},
				backend = { "telescope" },
			}
		end,
	}
}

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

require('docs-view').setup {
	position = "bottom",
}
