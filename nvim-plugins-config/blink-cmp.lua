require('lze').load {
	'friendly-snippets',
	event = "ExitPre",
	dep_of = "blink-cmp",
}

require('lze').load {
	'vim-snippets',
	event = "ExitPre",
	dep_of = "blink-cmp",
}
require('lze').load {
	'supermaven-nvim',
	event = "ExitPre",
	dep_of = "blink-cmp",
}

require('lze').load {
	'blink-cmp',
	event = "DeferredUIEnter",
	after = function()
		require("supermaven-nvim").setup {
			disable_inline_completion = true, -- disables inline completion for use with cmp
			disable_keymaps = true, -- disables built in keymaps for more manual control
			log_level = "off", -- Shut off the warnings
		}
		local blink = require("blink-cmp")
		local function custom_draw(ctx)
			return {{
				ctx.item.label,
				fill = true,
				hl_group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel'
			},
			{
				string.format("%s %s", ctx.kind_icon, ctx.item.blink.source),
				hl_group = 'BlinkCmpKind' .. ctx.kind,
			}}
		end
		blink.setup {
			keymap = {
				preset = 'enter',
				[ "<Tab>" ]   = {'select_next', 'fallback' },
				[ "<S-Tab>" ] = {'select_prev', 'fallback' },
				[ "<C-l>" ] = { 'snippet_forward' },
				[ "<C-j>" ] = { 'snippet_backward' },
			},
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},

			trigger = {
				signature_help = {
					enabled = false,
				}
			},
			sources = {
				completion = {
					enabled_providers = {
						'supermaven',
						'lsp',
						'path',
						'snippets',
						'buffer',
					},
				},
				providers = {
					supermaven = {
						name = 'Supermaven',
						module = 'supermaven',
						score_offset = 20,
					},
					path = {
						name = 'Path',
						module = 'blink.cmp.sources.path',
					},
					snippets = {
						name = 'Snippets',
						module = 'blink.cmp.sources.snippets',
						score_offset = -3,
						opts = {
							friendly_snippets = true,
							search_paths = { vim_snippets_path .. "/snippets", },
						},
					},
					-- maybe remove if lag
					buffer = {
						name = 'Buffer',
						module = 'blink.cmp.sources.buffer',
					}
				}
			},

			windows = {
				autocomplete = {
					border = "rounded",
					selection = 'auto_insert',
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},
				documentation = {
					border = "double",
					auto_show_delay_ms = 2000,
				},
				ghost_text = {
					enabled = false,
				},
			}
		}

		vim.cmd [[
		hi! link Pmenu Float
		hi! link PmenuSel CursorLine
		]]
	end,
	dep_of = "telescope.nvim",
}
