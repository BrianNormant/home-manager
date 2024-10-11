require('spellwarn').setup {
	event = { -- event(s) to refresh diagnostics on
		"BufWrite", "FileWritePost"
	},
	enable = true, -- enable diagnostics on startup
	ft_config = { -- spellcheck method: "cursor", "iter", or boolean
		alpha   = false,
		help    = false,
		lazy    = false,
		lspinfo = false,
		mason   = false,
		oil     = false,
		qf      = false,
	},
	ft_default = true, -- default option for unspecified filetypes
	max_file_size = nil, -- maximum file size to check in lines (nil for no limit)
	severity = { -- severity for each spelling error type (false to disable diagnostics for that type)
		spellbad   = "HINT",
		spellcap   = "INFO",
		spelllocal = "INFO",
		spellrare  = "INFO",
	},
	prefix = "possible misspelling(s): ", -- prefix for each diagnostic message
	diagnostic_opts = { severity_sort = true }, -- options for diagnostic display
}
