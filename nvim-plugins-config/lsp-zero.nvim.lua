local lsp_zero = require('lsp-zero')
local lsp_config = require('lspconfig')


--- Keybinds
local legend = {
	keymaps = {
		{'K',          vim.lsp.buf.hover,           mode={'n'}, description = "Lsp show/enter hover"},
		{'gi',         vim.lsp.buf.implementation,  mode={'n'}, description = "Lsp goto implementation"},
		{'go',         vim.lsp.buf.type_definition, mode={'n'}, description = "Lsp goto type definition"},
		-- {'gs',      vim.lsp.buf.signature_help,  mode={'n'}, description = "Lsp show type signature"},
		{'gD',         vim.lsp.buf.declaration,     mode={'n'}, description = "Lsp goto declaration"},
		{'gd',         vim.lsp.buf.definition,      mode={'n'}, description = "Lsp goto definition"},
		{'gR',         vim.lsp.buf.rename,          mode={'n'}, description = "Lsp rename symbol under cursor"},
		{'gr',         vim.lsp.buf.references,      mode={'n'}, description = "Lsp goto references"},
		{'<leader>gq', vim.diagnostic.setqflist,    mode={'n'}, description = "Lsp send diagnostics to quickfix"},
		{'<leader>gl', vim.diagnostic.setloclist,   mode={'n'}, description = "Lsp send diagnostics to loclist"},
		{"<leader>e",  vim.diagnostic.open_float,   mode={'n'}, description = "Lsp open/enter diagnostic window"},
	},
}

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
	'phpactor',
	'nushell',
}

lsp_config.elixirls.setup { cmd = { vim.fn.exepath('elixir-ls') }, }

_G.LEGEND_append(legend)
