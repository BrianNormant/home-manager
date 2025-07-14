{ pkgs, ... }: {
	programs = {
		walker = {
			enable = true;
			runAsService = true;
			config = {
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
		rofi = {
			enable = true;
			package = pkgs.rofi-wayland;
			theme = "gruvbox-dark-soft";
			plugins = let
				build-against-rofi-wayland = plugin: plugin.overrideAttrs ( final: self: {
					# version = "wayland";
					buildInputs = with pkgs; [
						rofi-wayland-unwrapped # here we replace rofi by rofi-wayland
						libqalculate
						glib
						cairo
					];
				});
				rofi-wayland-plugins = with pkgs; [
					rofi-calc
					rofi-emoji
				];
			in builtins.map build-against-rofi-wayland rofi-wayland-plugins;
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
