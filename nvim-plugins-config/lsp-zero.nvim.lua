require('lze').load {
	'nvim-lspconfig',
	event = "LspAttach",
	dep_of = { "lsp-zero.nvim" },
}
require('lze').load {
	'lsp-zero.nvim',
	ft = {
		"nix",
		"lua",
		"java",
		"c",
		"xml",
		"nu",
		"exilir",
	},
	after = function ()
		local lsp_zero = require('lsp-zero')
		local lsp_config = require('lspconfig')

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = 'LSP mappings',
			callback = function(ev)
				vim.keymap.set('n', 'K', function()
					local winid = require('ufo').peekFoldedLinesUnderCursor()
					if not winid then vim.lsp.buf.hover() end
				end)
				vim.keymap.set('n', 'H',          vim.lsp.buf.document_highlight, { buffer = ev.buf, desc = " Lsp highligh current symbol" } )
				vim.keymap.set('n', 'gi',         vim.lsp.buf.implementation,     { buffer = ev.buf, desc = " Lsp goto implementation" } )
				vim.keymap.set('n', 'go',         vim.lsp.buf.type_definition,    { buffer = ev.buf, desc = " Lsp goto type definition" } )
				vim.keymap.set('n', 'gI',         vim.lsp.buf.signature_help,     { buffer = ev.buf, desc = " Lsp show type signature" } )
				vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,        { buffer = ev.buf, desc = " Lsp goto declaration" } )
				vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,         { buffer = ev.buf, desc = " Lsp goto definition" } )
				-- inc-rename do this.
				-- vim.keymap.set('n', 'gR',         vim.lsp.buf.rename,             { buffer = ev.buf, desc = " Lsp rename symbol under cursor" } )
				vim.keymap.set('n', 'gr',         vim.lsp.buf.references,         { buffer = ev.buf, desc = " Lsp goto references" } )
				vim.keymap.set('n', "<leader>e",  vim.diagnostic.open_float,      { buffer = ev.buf, desc = " Lsp open/enter diagnostic window" } )
				vim.keymap.set('n', '<leader>lL', "<cmd>LspLog<cr>",              { buffer = ev.buf, desc = "Format the current buffer with the lsp" } )
				vim.keymap.set('n', '<leader>lS', "<cmd>LspStop<cr>",             { buffer = ev.buf, desc = "Stop the current lsp server" } )
				vim.keymap.set('n', '<leader>ld', vim.diagnostic.setqflist,       { buffer = ev.buf, desc = " Lsp send diagnostics to quickfix" } )
				vim.keymap.set('n', '<leader>lf', "<cmd>LspZeroFormat<cr>",       { buffer = ev.buf, desc = "Format the current buffer with the lsp" } )
				vim.keymap.set('n', '<leader>li', "<cmd>LspInfo<cr>",             { buffer = ev.buf, desc = "Info about the current lsp" } )
				vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist,      { buffer = ev.buf, desc = " Lsp send diagnostics to loclist" } )
				vim.keymap.set('n', '<leader>lr', "<cmd>LspRestart<cr>",          { buffer = ev.buf, desc = "Restart the current lsp server" } )
				vim.keymap.set('n', '<leader>ls', "<cmd>LspStart<cr>",            { buffer = ev.buf, desc = "Start lsp server for this filetype" } )
			end
		})
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
	end,
	dep_of = { "inc-rename.nvim", "idris2-nvim" },
}
