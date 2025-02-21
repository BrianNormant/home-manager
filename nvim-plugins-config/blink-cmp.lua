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
		blink.setup {
			keymap = {
				preset = 'enter',
				[ "<Tab>" ]   = {'select_next', 'fallback' },
				[ "<S-Tab>" ] = {'select_prev', 'fallback' },
				[ "<C-l>" ] = { 'snippet_forward' },
				[ "<C-j>" ] = { 'snippet_backward' },
			},
			sources = {
				default = {
					'supermaven',
					'lsp',
					'path',
					'snippets',
					'buffer',
				},
				providers = {
					supermaven = {
						name = 'Supermaven',
						module = 'supermaven',
						score_offset = 20,
					},
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
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

			completion = {
				list = {
					max_items = 50,
					selection = { preselect = false, auto_insert = true },
				},
				menu = {
					border = "rounded",
					draw = {
						columns = { { "label", "source", gap = 1}, { "kind_icon", "kind", } },
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx) return ctx.kind_icon .. ctx.icon_gap end,
								highlight = function(ctx)
									return (require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind') .. ctx.kind
								end,
							},

							kind = {
								ellipsis = false,
								width = { fill = true },
								text = function(ctx) return ctx.kind end,
								highlight = function(ctx)
									return (require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind') .. ctx.kind
								end,
							},
							label = {
								width = { fill = true, max = 60 },
								text = function(ctx) return ctx.label .. ctx.label_detail end,
								highlight = function(ctx)
									-- label and label details
									local highlights = {
										{ 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
									}
									if ctx.label_detail then
										table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
									end

									-- characters matched on the label by the fuzzy matcher
									for _, idx in ipairs(ctx.label_matched_indices) do
										table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
									end

									return highlights
								end,
							},
							source = {
								text = function(ctx) return ctx.source_name end,
								highlight = "BlinkCmpSource",
							}
						}
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
					window = { border = "double", }
				},
			},
			signature = {
				enabled = false,
			},
			fuzzy = {
				prebuilt_binaries = {
					ignore_version_mismatch = true,
					force_version = nil,
				}
			},
			cmdline = { enabled = false },
		}

		vim.cmd [[
		hi! link Pmenu Float
		hi! link PmenuSel CursorLine
		]]
	end,
	dep_of = "telescope.nvim",
}
