{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			muren = {
				enable = true;
				settings = {
					all_on_line    = false;
					patterns_width  = 50;
					options_width  = 20;
					patterns_height = 5;
					preview_height = 45;
					anchor = "center";
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
