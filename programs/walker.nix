{pkgs, ...}: {
	services = {
		walker = {
			enable = true;
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
		".config/walker/themes/gruvbox.css".source = ../config/walker/gruvbox.css;
		".config/walker/themes/gruvbox.toml".source = ../config/walker/gruvbox.toml;
	};
	home.packages = with pkgs; [
		libqalculate
	];
}
