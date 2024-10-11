local blink = require("blink-cmp")
local loaded = false
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

vim.api.nvim_create_autocmd({"UIEnter"}, {
	group = "Lazy",
	pattern = "*",
	callback = function()
		if loaded then return end
		loaded = true
		require("supermaven-nvim").setup {
			disable_inline_completion = true, -- disables inline completion for use with cmp
			disable_keymaps = true, -- disables built in keymaps for more manual control
			log_level = "off", -- Shut off the warnings
		}
		blink.setup {
			keymap = {
				accept = { "<CR>", },
				select_next = "<Tab>",
				select_prev = "<S-Tab>",
				snippet_forward = { "<Tab>", "<C-l>" },
				snippet_backward = { "<S-Tab>", "<C-j>" },
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
				providers = {
					{
						{
							'blink.cmp.sources.supermaven',
							score_offset = 20,
						},
						{ 'blink.cmp.sources.lsp' },
						{ 'blink.cmp.sources.path' },
						{
							'blink.cmp.sources.snippets',
							opts = {
								search_paths = { vim_snippets_path .. "/snippets", }
							},
							score_offset = -10,
						},
					},
					{ { 'blink.cmp.sources.buffer' } },
				},
			},

			windows = {
				autocomplete = {
					border = "rounded",
					draw = custom_draw,
					cycle = {
						from_bottom = true,
						from_top = true,
					},
					preselect = false,
				},
				documentation = {
					border = "double",
					auto_show_delay_ms = 2000,
				},
			}
		}

		vim.cmd [[
		hi! link Pmenu Float
		hi! link PmenuSel CursorLine
		]]
	end
})
