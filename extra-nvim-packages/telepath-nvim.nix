{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "telepath.nvim";
		version = "2879da0";
		src = fetchFromGitHub {
			owner = "rasulomaroff";
			repo = "telepath.nvim";
			rev = "2879da0"; # Fri Sep 27 05:01:10 PM EDT 2024
			hash = "sha256-h1NILk/EAbhb9jONHAApFs9Z2f8oZsWy15Ici6+TLxw=";
		};
	}
