{config, pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			leap = {
				enable = true;
			};
			flit = {
				enable = true;
				settings = {
					labeled_modes = "nvo";
				};
			};
			telepath = {
				enable = true;
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
				luaConfig.post = ''
					require('telepath').use_default_mappings()
					'';
			};
		};
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
