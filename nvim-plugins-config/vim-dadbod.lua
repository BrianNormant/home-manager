require('lze').load {
	'vim-dadbod',
	dep_of = { "vim-dadbod-ui" },
	event = "ExitPre",
}

require('lze').load {
	'vim-dadbod-ui',
	cmd = "DBUI",
	ft = {"sql", "psql"},
	after = function ()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.dbs = {
			-- ['DB Oracle locale'] = "oracle://SYSTEM:welcome123@localhost:1521/FREE"
		}
	end
}
