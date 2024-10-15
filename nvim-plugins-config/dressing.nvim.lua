require('lze').load {
	'dressing.nvim',
	event = "DeferredUIEnter",
	after = function ()
		require('dressing').setup {
			input = {
				enabled = true,
				border = 'single',
				override = function(conf)
					conf.col = -1
					conf.row = 0
					return conf
				end,
			},
			select = {
				enabled = false,
			},
		}
	end
}
