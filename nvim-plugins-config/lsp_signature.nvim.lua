require('lze').load({
	'lsp_signature.nvim',
	event = "LspAttach",
	after = function()
		require "lsp_signature".setup {
			bind = true,
			handler_opts = { border = "double", },
			hint_prefix = {
				above = "↙ ",  -- when the hint is on the line above the current line
				current = "← ",  -- when the hint is on the same line
				below = "↖ "  -- when the hint is on the line below the current line
			}
		}
	end
})
