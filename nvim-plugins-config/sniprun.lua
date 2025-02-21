require('lze').load {
	'sniprun',
	keys = {
		{'<F5>'},
	},
	after = function ()
		require('sniprun').setup {

		}
	end
