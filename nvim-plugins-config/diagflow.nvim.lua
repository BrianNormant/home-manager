require('lze').load {
	'diagflow.nvim',
	event = "LspAttach",
	after = function()
		require('diagflow').setup {
			show_borders = true,
			scope = "cursor",
			-- I'd prefer line but it shows even when not in the window + it clutter the
			-- window if there are many diagnostics on the line
			toggle_event = { "InsertEnter", "InsertLeave" },
			render_event = { "CursorMoved", "DiagnosticChanged" },
			update_event = { "DiagnosticChanged", "BufReadPost" },
			enable = function()
				-- TODO: disable if the buffer is to small
				local dis_ft = { "qf", "oil" }
				for _, ft in ipairs(dis_ft) do
					if ft == vim.bo.filetype then
						return false
					end
				end
				local dis_bf = { "quickfix" }
				for _, bf in ipairs(dis_bf) do
					if bf == vim.bo.buftype then
						return false
					end
				end
				return true
			end
		}
	end
}
