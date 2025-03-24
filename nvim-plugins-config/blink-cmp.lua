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
						columns = { { "label", "source_name", gap = 1}, { "kind_icon", "kind", } },
					},
				},
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 100,
					window = { border = "double", }
				},
			},
			signature = {
				enabled = true,
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
