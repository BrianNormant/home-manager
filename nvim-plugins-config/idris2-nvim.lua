require('lze').load {
	'idris2-nvim',
	ft = "idris2",
	after = function ()
		require('idris2').setup {
			-- autostart_semantic = true,
			-- use_default_semantic_hl_groups = true,
			-- default_regexp_syntax = false,
			code_action_post_hook = function (_)
				vim.cmd "silent write"
			end,
		}
	end
}

--- Keymaps
local legend = {
	commands = {
		{"IdrRepl", function ()
			require("idris2.repl").evaluate()
		end},
		{"IdrBrowse", function ()
			require("idris2.browse").browse()
		end},
		{"IdrDef", function ()
			require("idris2.code_action").generate_def()
		end},
		{"IdrSearch", function ()
			require("idris2.code_action").search()
		end},
	},
}
_G.legendary.append(legend)
