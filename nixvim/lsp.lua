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
			local colors = _G.get_colors()
			require('action-hints').setup {
				template = {
					definition = { text = "󰡱 ", color = colors.red },
					references = { text = "  %s", color = colors.purple },
				},
				use_virtual_text = true,
			}
		end,
	},
	{
		"symbol-usage.nvim",
		event = "LspAttach",
		after = function ()
			local function text_format(symbol)
				local fragments = {}
				-- Indicator that shows if there are any other symbols in the same line
				local stacked_functions = symbol.stacked_count > 0
					and (' | +%s'):format(symbol.stacked_count)
					or ''

				if symbol.references then
				  local usage = symbol.references <= 1 and 'usage' or 'usages'
				  local num = symbol.references == 0 and 'no' or symbol.references
				  table.insert(fragments, ('%s %s'):format(num, usage))
				end

				if symbol.definition then
				  table.insert(fragments, symbol.definition .. ' defs')
				end

				if symbol.implementation then
				  table.insert(fragments, symbol.implementation .. ' impls')
				end

				return table.concat(fragments, ', ') .. stacked_functions
			end

			require('symbol-usage').setup {
				text_format = text_format,
				references = {enabled = true, include_declaration = false},
				definitions = {enabled = true},
				implementation = {enabled = true},
			}
		end
	}
}
