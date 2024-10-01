require('diagflow').setup {
	show_borders = true,
	scope = "line",
	toggle_event = { "InsertEnter", "InsertLeave" },
	render_event = { "CursorMoved", "DiagnosticChanged" },
	update_event = { "DiagnosticChanged", "BufReadPost" },
	enable = function()
		local dis_ft = { "qf", "oil" }
		for _, ft in ipairs(dis_ft) do
			if ft == vim.bo.filetype then
				return false
			end
		end
		return true
	end
}
