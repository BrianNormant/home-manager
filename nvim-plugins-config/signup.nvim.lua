require('lze').load {
	"signup.nvim",
	event = "BufEnter",
	after = function ()
		require('signup').setup {
			dock_mode = {
				enabled = true,
			}
		}
	end
}
