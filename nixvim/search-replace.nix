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
				lazyLoad.settings = {
					keys = [
						{
						__unkeyed-1 = "<F3>";
						__unkeyed-2 = "<Cmd>MurenToggle<CR>";
						mode = [ "n" ];
						}
						{
						__unkeyed-1 = "<F3>";
						__unkeyed-2 = ":'<,'>MurenToggle<CR>";
						mode = [ "v" ];
						}
					];
				};
			};
			spectre = {
				enable = true;
				lazyLoad.settings = {
					keys = [{
						__unkeyed-1 = "<S-F3>";
						__unkeyed-2 = "<Cmd>Spectre<CR>";
						mode = [ "n" ];
					}];
				};
			};
		};
	};
}
