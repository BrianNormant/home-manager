require("supermaven-nvim").setup {
	disable_inline_completion = true, -- disables inline completion for use with cmp
	disable_keymaps = true, -- disables built in keymaps for more manual control
}

local cmp = require( 'cmp' )
local lspkind = require('lspkind')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
cmp.setup {
	preselect = cmp.PreselectMode.None,
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = { format = lspkind.cmp_format {
		mode = "symbol_text",
		menu = ({
			buffer = "[Buffer]",
			maxWidth = 50,
			ellipsis_char = '...',
			show_labelDetails = true,
			nvim_lsp = "[LSP]",
			nvim_lsp_document_symbol = "[LSP Symbol]",
			luasnip = "[LuaSnip]",
			treesitter = "[Treesitter]",
			supermaven = "[SuperMaven]",
			async_path = "[File]",
			spell = "[Spell]",
		}),
		details = true
	}, },
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	-- window = { border = "single" },
	mapping = cmp.mapping.preset.insert({
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm { select = false; },
		['<C-space>'] = cmp.mapping.complete(),
		['<M-space>'] = cmp.mapping.complete{ ["config.sources.name"] = "luasnip" },
		--- https://www.reddit.com/r/neovim/comments/10r7l63/comment/jfx72u9/
		['<Down>'] = cmp.mapping(function(fallback)
			cmp.close()
			fallback()
		end, { 'i', 's' }),
		['<Up>'] = cmp.mapping(function(fallback)
			cmp.close()
			fallback()
		end, { 'i', 's' }),
		['<Tab>'] = cmp_action.luasnip_supertab(),
		['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
	}),

	sources = cmp.config.sources {
		{ name = 'nvim_lsp' },
		{ name = 'treesitter' },
		{ name = 'luasnip' },
		{ name = 'async_path' },
		{ name = "supermaven" },
	}
}
--- Customize cmp-nvim pop up look

vim.opt_global.pumheight = 10
vim.cmd [[
	hi! link Pmenu Float
	hi! link PmenuSel Float
]]

vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = { "*.sql", "*.plsql" },
  callback = function()
	  cmp.setup.buffer({
		  source = {
			  { name = "vim-dadbod-completion" },
		  }
	  })
  end
})
