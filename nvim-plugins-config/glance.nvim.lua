require('lze').load {
	'glance-nvim',
	event = { "BufEnter" },
	after = function()
		require('glance').setup {
		}
	end
}
