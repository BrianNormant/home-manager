local lsp_zero = require('lsp-zero')
local lsp_config = require('lspconfig')

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
	local opts = {buffer = bufnr}
	vim.keymap.set('n',  'K',   vim.lsp.buf.hover,            opts)
	vim.keymap.set('n',  'gi',  vim.lsp.buf.implementation,   opts)
	vim.keymap.set('n',  'go',  vim.lsp.buf.type_definition,  opts)
	vim.keymap.set('n',  'gs',  vim.lsp.buf.signature_help,   opts)
	vim.keymap.set('n',  'gD',  vim.lsp.buf.declaration,      opts)
	vim.keymap.set('n',  'gd',  vim.lsp.buf.definition,       opts)
	vim.keymap.set('n',  'gR',  vim.lsp.buf.rename,           opts)
	vim.keymap.set('n',  'gr',  vim.lsp.buf.references,       opts)
end

lsp_zero.extend_lspconfig {
	sign_text = true,
	lsp_attach = lsp_attach,
	capabilities = coq.lsp_ensure_capabilities(),
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
	'phpactor',
	'nushell',
}

lsp_config.elixirls.setup { cmd = { vim.fn.exepath('elixir-ls') }, }
