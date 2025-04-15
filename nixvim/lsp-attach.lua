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
