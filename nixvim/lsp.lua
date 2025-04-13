require('lz.n').load {
	{
		'goto-preview',
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
	},
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
		"nvim-docs-view",
		cmd = "DocsViewToggle",
		after = function ()
			require('docs-view').setup {
				position = "bottom",
			}
		end,
	},
	{
		"action-hints.nvim",
		event = "LspAttach",
		after = function ()
			local contrast = _G.gruvbox_contrast
			local g_colors = require("gruvbox-material.colors")
			local colors = g_colors.get(vim.o.background, contrast)
			require('action-hints').setup {
				template = {
					definition = { text = "󰡱 ", color = colors.red },
					references = { text = "  %s", color = colors.purple },
				},
				use_virtual_text = true,
			}
		end,
	},
}
