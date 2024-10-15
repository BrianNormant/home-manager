require('lze').load {
	'idris2-nvim',
	ft = "idris2",
	after = function ()
		require('idris2').setup {}
	end
}

--- Keymaps
local legend = {
	commands = {
		{":IdrisEvaluate", function()
			require('idris2.repl').evalutate()
		end, description="Use Idris2 lsp to evalutate a expression sourcing the file"},
		{":IdrisCasesplit", function()
			require('idris2.code_action').case_split()
		end, description="Idris2 lsp Case split"},
		{":IdrisExprSearch", function()
			require('idris2.code_action').expr_search()
		end, description="Idris2 lsp expression search"},
		{":IdrisGenDef", function()
			require('idris2.code_action').generate_def()
		end, description="Idris2 lsp Try to generate a definition"},
	},
}
_G.legendary.append(legend)
