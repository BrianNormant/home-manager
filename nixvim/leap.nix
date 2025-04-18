{config, pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			leap = {
				enable = true;
				addDefaultMappings = false;
			};
			flit.enable = true;
			flit.settings = {
				labeled_modes = "nvo";
			};
		};
		extraPlugins = [
			{
				plugin = pkgs.vimUtils.buildVimPlugin rec {
					pname = "telepath.nvim";
					version = "2879da0";
					src = pkgs.fetchFromGitHub {
						owner = "rasulomaroff";
						repo = "telepath.nvim";
						rev = "2879da0"; # Fri Sep 27 05:01:10 PM EDT 2024
						hash = "sha256-h1NILk/EAbhb9jONHAApFs9Z2f8oZsWy15Ici6+TLxw=";
					};
				};
				optional = true;
			}
		];
		extraConfigLua = ''
			require('lz.n').load { {
				"telepath.nvim",
				event = "DeferredUIEnter",
				after = function()
					require('telepath').use_default_mappings()
				end,
			} }
		'';
		highlightOverride = {
			LeapBackdrop = { fg = "#888888"; };
			LeapLabel    = { fg = "#FF0000"; bold = true;};
		};
		keymaps = [
			{
				key = "x";
				action = "<Plug>(leap-forward)";
				mode = [ "n" "x" "o" ];
				options.desc = "Leap forward";
			}
			{
				key = "X";
				action = "<Plug>(leap-backward)";
				mode = [ "n" "x" "o" ];
				options.desc = "Leap backward";
			}
			{
				key = "r";
				action = "<Plug>(leap-from-window)";
				mode = [ "n" "x" ]; # operator mode is replaced by telepath
				options.desc = "Leap Anywhere";
			}
		];
	};
}
