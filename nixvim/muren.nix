{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			muren = {
				enable = true;
				settings = {
					all_on_line = false;
					pattern_witdh = 75;
					pattern_heigh = 10;
					options_width = 25;
					preview_height = 12;
					anchor = "top";
				};
			};
		};
		keymaps = [ {
			key = "<F3>";
			action = "<Cmd>MurenToggle<CR>";
			mode = [ "n" "v" ];
			options.desc = "Muren: Search And Replace";
		} ];
	};
}
