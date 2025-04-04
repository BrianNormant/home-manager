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

local contrast = "soft"
local g_colors = require("gruvbox-material.colors")
local colors = g_colors.get(vim.o.background, contrast)

require('action-hints').setup {
	template = {
		definition = { text = "󰡱 ", color = colors.red },
		references = { text = "  %s", color = colors.purple },
	},
	use_virtual_text = true,
}

local function text_format(symbol)
  local fragments = {}

  -- Indicator that shows if there are any other symbols in the same line
  local stacked_functions = symbol.stacked_count > 0
      and (' | +%s'):format(symbol.stacked_count)
      or ''

  if symbol.references then
    local usage = symbol.references <= 1 and 'usage' or 'usages'
    local num = symbol.references == 0 and 'no' or symbol.references
    table.insert(fragments, ('%s %s'):format(num, usage))
  end

  if symbol.definition then
    table.insert(fragments, symbol.definition .. ' defs')
  end

  if symbol.implementation then
    table.insert(fragments, symbol.implementation .. ' impls')
  end

  return table.concat(fragments, ', ') .. stacked_functions
end

require('symbol-usage').setup {
  text_format = text_format,
  references = {enabled = true, include_declaration = false},
  definitions = {enabled = true},
  implementation = {enabled = true},
}
