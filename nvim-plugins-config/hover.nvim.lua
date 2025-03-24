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

		vim.keymap.set('n', 'K', hover.hover)
		vim.keymap.set('n', 'gK', hover.hover_select)
		vim.keymap.set("n", "g]", function() hover.hover_switch("previous") end)
        vim.keymap.set("n", "g[", function() hover.hover_switch("next") end)
		vim.keymap.set('n', '<MouseMove>', hover.hover_mouse)
		vim.o.mousemoveevent = true;
	end
}
