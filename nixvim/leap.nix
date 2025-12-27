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
				action = "<Plug>(leap)";
				mode = [ "n" "x" "o" ];
				options.desc = "Leap in window";
			}
			{
				key = "X";
				action = "<Plug>(leap-anywhere)";
				mode = [ "n" "x" "o" ];
				options.desc = "Leap anywhere";
			}
		];
	};
}
