{pkgs, ... }:
let
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		extraPlugins = with vimPlugins; [
			# Lazy load manually
			{
				plugin = nvim-navbuddy;
				optional = true;
			}
		];

		extraConfigLua = ''
			require('lz.n').load { {
				"nvim-navbuddy",
				cmd = "Navbuddy",
				before = function()
					-- require("lz.n").trigger_load "nvim-navic"
					-- require("lz.n").trigger_load "nui.nvim"
				end,
				after = function()
					local actions = require("nvim-navbuddy.actions")
					require("nvim-navbuddy").setup {
						lsp = { auto_attach = true },
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

		plugins = {
			aerial = {
				enable = true;
				lazyLoad.settings.event = [ "LspAttach" ];
				settings = {
					layout = {
						placement = "edge";
					};
					attach_mode = "global";
				};
			};
		};
		keymaps = [
			{
				key = "L";
				action = "<Cmd>AerialToggle! left<cr>";
				options.desc = "Aerial";
			}
			{
				key = "<C-l>";
				action = "<Cmd>Navbuddy<cr>";
				options.desc = "Navbuddy";
			}
		];
	};
}
