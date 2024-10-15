require('lze').load {
	"comment.nvim",
	keys = {
		{"gc",  desc = "Toggle line Comment",  mode = { "n", "o", "x"}},
		{"gcc", desc = "Toggle line Comment",  },
		{"gb",  desc = "Toggle block Comment", mode = { "n", "x"}},
		{"gco", desc = "Inserts comment below and enters INSERT mode"},
		{"gcO", desc = "Inserts comment above and enters INSERT mode"},
		{"gcA", desc = "Inserts comment at the end of line and enters INSERT mode"},
	},
	after = function ()
		require ('Comment').setup()
	end,
}
