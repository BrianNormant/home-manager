--[[
local tabnine = require('cmp_tabnine.config')

tabnine:setup({
	max_lines = 1000,
	max_num_results = 5,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = '..',
	ignored_file_types = {
		-- default is not to ignore
		-- uncomment to ignore in lua:
		-- lua = true
	},
	show_prediction_strength = true,
	min_percent = 50,
})

local prefetch = vim.api.nvim_create_augroup("prefetch", {clear = true})
vim.api.nvim_create_autocmd('BufRead', {
	group = prefetch,
	pattern = '*',
	callback = function()
		require('cmp_tabnine'):prefetch(vim.fn.expand('%:p'))
	end
})
]]--

-- TODO remove "" {} () and other single characters from completion
require("supermaven-nvim").setup {
	disable_inline_completion = true, -- disables inline completion for use with cmp
	disable_keymaps = true, -- disables built in keymaps for more manual control
}

local cmp = require( 'cmp' )
local luasnip = require("luasnip")
local lspkind = require('lspkind')
local cmp_action = require('lsp-zero').cmp_action()

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
			latex_symbols = "[Latex]",
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
		['<C-g>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
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
		-- { name = 'nvim_lsp_document_symbol' },
		{ name = 'treesitter' },
		{ name = 'luasnip' },
		{ name = 'async_path' },
		-- { name = "buffer" },

		--- Random guess
		{ name = "supermaven" },
		{ name = "spell" },
		{
			name = "latex_symbols",
			option = { strategy = 1, },
		},

	}
}
--- Customize cmp-nvim popup look

vim.opt.pumheight = 10
vim.cmd [[
	hi! link Pmenu Float
	hi! link PmenuSel Float
]]

--- Add delay to cmp-nvim completion
--[[ local timer = nil
vim.api.nvim_create_autocmd({ "TextChangedI", "CmdlineChanged" }, {
  pattern = "*",
  callback = function()
    if timer then
      vim.loop.timer_stop(timer)
      timer = nil
    end

    timer = vim.loop.new_timer()
    timer:start(200, 0, vim.schedule_wrap(function()
      require('cmp').complete({ reason = require('cmp').ContextReason.Auto })
    end))
  end
}) ]]
