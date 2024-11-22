require('lze').load {
	"comment.nvim",
	keys = {
		{"gc",  desc = "Toggle line Comment",  mode = { "n", "o", "x"}},
		{"gb",  desc = "Toggle block Comment", mode = { "n", "x"}},
	},
	after = function ()
		require ('Comment').setup()
	end,
}
