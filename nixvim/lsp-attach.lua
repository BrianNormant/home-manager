-- client and bufnr are provided

-- Auto Highlight
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

-- Inlay Hints on current line
local inlay_hints_group = vim.api.nvim_create_augroup('LSP_inlayHints', { clear = false })

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

require('action-hints').setup {}
