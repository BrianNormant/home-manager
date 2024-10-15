require('lze').load {
	'mini.extra',
	after = function()
		require('mini.extra').setup {}
	end,
	dep_of = {
		'mini.ai',
	}
}
