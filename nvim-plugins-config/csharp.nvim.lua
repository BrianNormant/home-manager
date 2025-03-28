require('lze').load {
	"csharp.nvim",
	ft = "cs",
	after = function ()
		require("csharp").setup {
		}
	end,
}
