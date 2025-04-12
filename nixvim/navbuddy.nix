{pkgs, ... }:
let
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		extraPlugins = with vimPlugins; [ nvim-navbuddy ];

		extraConfigLua = ''
			require('lz.n').load { {
				"nvim-navbuddy",
				cmd = "Navbuddy",
				event = "LspAttach",
				after = function()
					local actions = require("nvim-navbuddy.actions")
					require("nvim-navbuddy").setup {
						window = { border = "double" },
						mappings = {
							["<Up>"]    = actions.previous_sibling(),
							["<Down>"]  = actions.next_sibling(),
							["<Right>"] = actions.children(),
							["<Left>"]  = actions.parent(),
						},
					}
				end
			} }
		'';

		keymaps = [{
			key = "L";
			action = "<Cmd>Navbuddy<cr>";
			options.desc = "Navbuddy";
		}];
	};
}
