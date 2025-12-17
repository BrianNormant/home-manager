require('lz.n').load {
	{
		"hover.nvim",
		event = "LspAttach",
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
		end,
	},
	{
		"outline-nvim",
		cmd = {
			"Outline",
		},
		keys = {
			{ "L", "<Cmd>Outline<cr>", desc = "Outline" },
		},
		after = function ()
			local outline = require('outline')
			outline.setup {
				outline_window = {
					position = "left",
					focus_on_open = false,
				},
			}
		end
	}
}
