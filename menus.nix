{ pkgs, ... }: {
	services = {
		walker = {
			enable = true;
			package = pkgs.walker;
			systemd.enable = true;
			settings = {
				as_window = false;
				builtins = {
					applications = {
						actions = { enabled = true; };
						show_generic = true;
						refresh = true;
						weight = 10;
					};
					calc = {
						min_chars = 3; # 2+2
					};
				};
			};
			theme = {
				name = "gruvbox";
				style = builtins.readFile ./config/walkerstyle.css;
			};
		};
	};
	programs = {
		rofi = {
			enable = true;
			theme = "gruvbox-dark-soft";
			plugins = with pkgs; [
					rofi-calc
					rofi-emoji
				];
		};
		fzf = {
			enable = true;
			tmux = {
				enableShellIntegration = true;
				shellIntegrationOptions = [ "-p 80%,35%" ];
			};
		};
	};
	home.packages = with pkgs; [
		libqalculate
		ov # pager
	];
}
