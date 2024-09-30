require('idris2').setup {}

--- Keymaps
local legend = {
	commands = {
		{":IdrisEvaluate",   require('idris2.repl').evalutate,           description="Use Idris2 lsp to evalutate a expression sourcing the file"},
		{":IdrisCasesplit",  require('idris2.code_action').case_split,   description="Idris2 lsp Case split"},
		{":IdrisExprSearch", require('idris2.code_action').expr_search,  description="Idris2 lsp expression search"},
		{":IdrisGenDef",     require('idris2.code_action').generate_def, description="Idris2 lsp Try to generate a definition"},
	},
}
_G.LEGEND_append(legend)
