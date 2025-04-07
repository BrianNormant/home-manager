{pkgs, ... }: {
	programs.nixvim =
	let
		highlight = [
			"Comment"
			"RainbowRed"
			"RainbowYellow"
			"RainbowBlue"
			"RainbowOrange"
			"RainbowGreen"
			"RainbowViolet"
			"RainbowCyan"
		];
	in {
		plugins = {
			rainbow-delimiters = {
				inherit highlight;
				enable = true;
			};
			indent-blankline = {
				lazyLoad.settings = {
					event = [ "DeferredUIEnter" ];
				};
				enable = true;
				settings = {
					indent = {
						inherit highlight;
						char = "▏";
						tab_char = "·";
					};
					scope = {
						enabled = true;
						highlight = "Blue";
						char = "║";
						show_end = false;
					};
				};
			};
		};
		highlightOverride = {
			RainbowRed    = { fg = "#E06C75"; };
			RainbowYellow = { fg = "#E5C07B"; };
			RainbowBlue   = { fg = "#61AFEF"; };
			RainbowOrange = { fg = "#D19A66"; };
			RainbowGreen  = { fg = "#98C379"; };
			RainbowViolet = { fg = "#C678DD"; };
			RainbowCyan   = { fg = "#56B6C2"; };
		};
	};
}
