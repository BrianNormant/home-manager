vim.api.nvim_create_autocmd({"LspAttach"},{
	group = "Lazy",
	pattern = "*",
	callback = function()
		require "lsp_signature".setup {
			bind = true,
			handler_opts = {
				border = "rounded",
			},
			hint_prefix = {
				above = "↙ ",  -- when the hint is on the line above the current line
				current = "← ",  -- when the hint is on the same line
				below = "↖ "  -- when the hint is on the line below the current line
			}
		}
	end
})
