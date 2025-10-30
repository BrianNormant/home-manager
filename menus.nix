{ pkgs, ... }: {
	services = {
		walker = {
			enable = true;
			package = pkgs.walker;
			systemd.enable = true;
			settings = {
				# theme = "gruvbox";
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
		};
	};
	home.file = {
		".config/walker/themes/gruvbox.css".source = ./config/walker/gruvbox.css;
		".config/walker/themes/gruvbox.toml".source = ./config/walker/gruvbox.toml;
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
