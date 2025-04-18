{pkgs, ... }: {
	programs.nixvim =
	let
		highlight = [
			"RainbowComment"
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
						char = "";
						tab_char = "·";
					};
					scope = {
						enabled = true;
						highlight = "CurrentScope";
						char = "";
						show_end = false;
					};
				};
			};
		};
		highlightOverride = {
			RainbowComment = { fg = "#928374"; };
			RainbowRed    = { fg = "#E06C75"; };
			RainbowYellow = { fg = "#E5C07B"; };
			RainbowBlue   = { fg = "#61AFEF"; };
			RainbowOrange = { fg = "#D19A66"; };
			RainbowGreen  = { fg = "#98C379"; };
			RainbowViolet = { fg = "#C678DD"; };
			RainbowCyan   = { fg = "#56B6C2"; };
			CurrentScope  = { fg = "#FFAF00"; bold=true;};
		};
	};
}
