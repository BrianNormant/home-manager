local blink = require("blink-cmp")

local function custom_draw(ctx)
	return {{
		ctx.item.label,
		fill = true,
		hl_group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel'
	},
	{
		string.format("%s %13s", ctx.kind_icon, ctx.kind),
		hl_group = 'BlinkCmpKind' .. ctx.kind,
	}}
	
end

blink.setup {
	keymap = {
		accept = "<CR>",
		select_next = "<Tab>",
		select_prev = "<S-Tab>",
		snippet_forward = { "<Tab>", "<C-l>" },
		snippet_backward = { "<S-Tab>", "<C-j>" },
	},

	accept = {
		auto_brackets = {
			enabled = true,
		}
	},

	trigger = {
		signature_help = {
			enabled = false,
		}
	},
	sources = {
		providers = {
			{
				{ 'blink.cmp.sources.lsp' },
				{ 'blink.cmp.sources.path' },
				{
					'blink.cmp.sources.snippets',
					opts = {
						search_paths = { vim_snippets_path .. "/snippets", }
					}
				},
			},
			{ { 'blink.cmp.sources.buffer' } },
		},
	},

	windows = {
		autocomplete = {
			border = "rounded",
			draw = custom_draw,
		},
		documentation = {
			border = "double",
			auto_show_delay_ms = 2000,
		}
	}
}

vim.cmd [[
	hi! link Pmenu Float
	hi! link PmenuSel CursorLine
]]
