{
pkgs,
lib,
...
}:
let
	cmus-gruvbox = pkgs.fetchurl {
		url = "https://raw.githubusercontent.com/thriveth/Gruvbox-goodies/c12f43df5e45b572986eca084a43d890d7ee00ed/cmus/gruvbox-night.theme";
		hash = "sha256-LWl2wOJj8q9plX3VzL/4wNBRsQKgMLlY0p3guiKEyp4=";
	};
in
	{
	programs = {
		cmus = {
			enable = true;
			theme = "Gruvbox-Night";
		};
		beets = {
			enable = true;
			settings = {
				import = {
					copy = false;
					autotag = true;
					write = true;
				};
				plugins = [
					"chroma"
					"fromfilename"
					"lastgenre"
				];
				chroma = {
					auto = true;
				};
			};
		};
	};
	home.file = {
		".config/cmus/Gruvbox-Night.theme".source = cmus-gruvbox;
	};
	services = {
		easyeffects = {
			enable = true;
		};
	};
}
