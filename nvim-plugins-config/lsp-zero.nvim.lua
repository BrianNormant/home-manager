local lsp_zero = require('lsp-zero')
local lsp_config = require('lspconfig')


--- Keybinds
local legend = {
	keymaps = {
		{'K',          function()
			local winid = require('ufo').peekFoldedLinesUnderCursor()
			if not winid then vim.lsp.buf.hover() end
		end,           mode={'n'}, description = "Lsp show/enter hover"},
		{'H',          vim.lsp.buf.document_highlight, mode={'n'}, description = "Lsp highligh current symbol"},
		{'gi',         vim.lsp.buf.implementation,  mode={'n'}, description = "Lsp goto implementation"},
		{'go',         vim.lsp.buf.type_definition, mode={'n'}, description = "Lsp goto type definition"},
		-- {'gs',      vim.lsp.buf.signature_help,  mode={'n'}, description = "Lsp show type signature"},
		{'gD',         vim.lsp.buf.declaration,     mode={'n'}, description = "Lsp goto declaration"},
		{'gd',         vim.lsp.buf.definition,      mode={'n'}, description = "Lsp goto definition"},
		{'gR',         vim.lsp.buf.rename,          mode={'n'}, description = "Lsp rename symbol under cursor"},
		-- {'gr',         vim.lsp.buf.references,      mode={'n'}, description = "Lsp goto references"},
		{"<leader>e",  vim.diagnostic.open_float,   mode={'n'}, description = "Lsp open/enter diagnostic window"},

		{"<leader>l", description = "lsp actions"},
		{'<leader>lL', "<cmd>LspLog<cr>",         mode={'n'}, description = "Format the current buffer with the lsp"},
		{'<leader>lS', "<cmd>LspStop<cr>",        mode={'n'}, description = "Stop the current lsp server"},
		{'<leader>ld', vim.diagnostic.setqflist,  mode={'n'}, description = "Lsp send diagnostics to quickfix"},
		{'<leader>lf', "<cmd>LspZeroFormat<cr>",  mode={'n'}, description = "Format the current buffer with the lsp"},
		{'<leader>li', "<cmd>LspInfo<cr>",        mode={'n'}, description = "Info about the current lsp"},
		{'<leader>ll', vim.diagnostic.setloclist, mode={'n'}, description = "Lsp send diagnostics to loclist"},
		{'<leader>lr', "<cmd>LspRestart<cr>",     mode={'n'}, description = "Restart the current lsp server"},
		{'<leader>ls', "<cmd>LspStart<cr>",       mode={'n'}, description = "Start lsp server for this filetype"},
	},
}

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
	pattern = {"*"},
	callback = function(_) vim.lsp.buf.document_highlight() end
})
vim.api.nvim_create_autocmd({"CursorMoved"}, {
	pattern = {"*"},
	callback = function(_) vim.lsp.buf.clear_references() end
})

--[[ -- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
	local opts = {buffer = bufnr}
	for _,v in pairs(legend_b.keymaps) do
		vim.keymap.set(v.mode, v[1], v[2], opts)
	end
end ]]
-- local legend = { keymaps = vim.tbl_map(function(v) return {v[1], mode = v.mode, description = v.description} end, legend_b.keymaps) }

lsp_zero.extend_lspconfig {
	sign_text = true,
	lsp_attach = function(_, _) end,
	capabilities = require('cmp_nvim_lsp').default_capabilities()
}

lsp_zero.ui {
	sign_text = {
		error = '✘',
		warn = '▲',
		hint = '⚑',
		info = '»',
	},
	float_border = "single"
}

-- These are just examples. Replace them with the language
-- servers you have installed in your system
lsp_zero.setup_servers {
	'clangd',
	'lua_ls',
	'nil_ls',
	'lemminx',
	'phpactor',
	'nushell',
}

lsp_config.elixirls.setup { cmd = { vim.fn.exepath('elixir-ls') }, }

_G.LEGEND_append(legend)
