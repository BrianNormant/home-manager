require('diagflow').setup {
	show_borders = true,
	scope = "line",
	toggle_event = { "InsertEnter", "InsertLeave" },
	render_event = { "CursorMoved" },
	update_event = { "DiagnosticChanged", "BufReadPost" },
}
