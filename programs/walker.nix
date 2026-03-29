{pkgs, ...}: {
	programs = {
		walker = {
			enable = true;
			runAsService = true;
			config = {
				providers = {
					default = [
						"desktopapplications"
						"providerlist"
						"calc"
						"runner"
						"websearch" "bookmarks"
					];
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
