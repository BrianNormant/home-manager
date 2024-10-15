require('lze').load {
	'codewindow.nvim',
	cmd = { 'CodeWindow' },
	keys = {
		{ "<Space>cc", "<cmd>CodeWindow toggle<cr>" },
	},
	after = function ()
		require("codewindow").setup {
			auto_enable = false,
			show_cursor = false,
			relative = "editor",
			exclude_filetypes = {
				'help', 'oil', 'telescope', 'Navbuddy'
			},
		}

		require('legendary').setup {
			commands = {
				{ ":CodeWindow", function(args)
					local fargs = args.fargs
					local f = {
						open = require('codewindow').open_minimap,
						close = require('codewindow').close_minimap,
						toggle = require('codewindow').toggle_minimap,
					}
					f[fargs[1]]()
				end, unfinished = true, opts = { nargs = 1 }}
			}
		}
	end
}
