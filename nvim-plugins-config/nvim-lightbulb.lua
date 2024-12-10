require('lze').load {
	'nvim-lightbulb',
	event = "LspAttach",
	after = function ()
		require('nvim-lightbulb').setup {
			number = { enabled = true, },
			-- sign = { enabled = true, },
			autocmd = { enabled = true, },
		}
	end
}
