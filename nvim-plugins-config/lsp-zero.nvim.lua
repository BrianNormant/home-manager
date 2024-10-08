local lsp_zero = require('lsp-zero')
local lsp_config = require('lspconfig')


--- Keybinds
local legend = {
	keymaps = {
		{'K',          function()
			local winid = require('ufo').peekFoldedLinesUnderCursor()
			if not winid then vim.lsp.buf.hover() end
		end,           mode={'n'}, description = "Lsp show/enter hover"},
		{'H',          vim.lsp.buf.document_highlight, mode={'n'}, description = " Lsp highligh current symbol"},
		{'gi',         vim.lsp.buf.implementation,  mode={'n'}, description = " Lsp goto implementation"},
		{'go',         vim.lsp.buf.type_definition, mode={'n'}, description = " Lsp goto type definition"},
		{'gI',         vim.lsp.buf.signature_help,  mode={'n'}, description = " Lsp show type signature"},
		{'gD',         vim.lsp.buf.declaration,     mode={'n'}, description = " Lsp goto declaration"},
		{'gd',         vim.lsp.buf.definition,      mode={'n'}, description = " Lsp goto definition"},
		{'gR',         vim.lsp.buf.rename,          mode={'n'}, description = " Lsp rename symbol under cursor"},
		{'gr',         vim.lsp.buf.references,      mode={'n'}, description = " Lsp goto references"},
		{"<leader>e",  vim.diagnostic.open_float,   mode={'n'}, description = " Lsp open/enter diagnostic window"},

		{"<leader>l", description = "lsp actions"},
		{'<leader>lL', "<cmd>LspLog<cr>",         mode={'n'}, description = "Format the current buffer with the lsp"},
		{'<leader>lS', "<cmd>LspStop<cr>",        mode={'n'}, description = "Stop the current lsp server"},
		{'<leader>ld', vim.diagnostic.setqflist,  mode={'n'}, description = " Lsp send diagnostics to quickfix"},
		{'<leader>lf', "<cmd>LspZeroFormat<cr>",  mode={'n'}, description = "Format the current buffer with the lsp"},
		{'<leader>li', "<cmd>LspInfo<cr>",        mode={'n'}, description = "Info about the current lsp"},
		{'<leader>ll', vim.diagnostic.setloclist, mode={'n'}, description = " Lsp send diagnostics to loclist"},
		{'<leader>lr', "<cmd>LspRestart<cr>",     mode={'n'}, description = "Restart the current lsp server"},
		{'<leader>ls', "<cmd>LspStart<cr>",       mode={'n'}, description = "Start lsp server for this filetype"},
	},
}

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
	pattern = {"*"},
	callback = function(_)
		local clients = vim.lsp.get_clients(
		{ bufnr = vim.api.nvim_get_current_buf() }
		)
		for _, c in ipairs(clients) do
			if c.supports_method('textDocument/documentHighlight') then
				vim.lsp.buf.document_highlight()
				break
			end
		end
	end
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
local inlay_hints_group = vim.api.nvim_create_augroup('LSP_inlayHints', { clear = false })
lsp_zero.extend_lspconfig {
	sign_text = true,
	lsp_attach = function(client, bufnr)
		-- if (vim.bo.filetype == 'lua') then return end
		if (client.supports_method('textDocument/inlayHint')) then
			vim.api.nvim_create_autocmd({'InsertLeave', 'CursorHold', 'CursorMoved'}, {
				group = inlay_hints_group,
				desc = 'Update inlay hints on line change',
				buffer = bufnr,
				callback = function()
					vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
				end,
			})
			vim.api.nvim_create_autocmd({"InsertEnter"}, {
				group = inlay_hints_group,
				desc = 'Remove inlay hints before insert',
				buffer = bufnr,
				callback = function()
					vim.lsp.inlay_hint.enable(false, {bufnr = bufnr})
				end
			})
		end
	end,
}

lsp_zero.ui {
	sign_text = {
		error = '' ,
		warn  = '',
		hint  = '',
		info  = ''
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

-- https://github.com/neovim/neovim/issues/28261#issuecomment-2130338921
-- Show inlay hints for the current line
local methods = vim.lsp.protocol.Methods
local inlay_hint_handler = vim.lsp.handlers[methods["textDocument_inlayHint"]]
vim.lsp.handlers[methods["textDocument_inlayHint"]] = function(err, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and result then
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    result = vim.iter(result)
      :filter(function(hint)
        return hint.position.line + 1 == row
      end)
      :totable()
  end
  inlay_hint_handler(err, result, ctx, config)
end

_G.LEGEND_append(legend)
