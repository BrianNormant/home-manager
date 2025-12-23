{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "bars-nvim";
		version = "latest-2025-12";
		src = fetchFromGitHub {
			owner = "OXY2DEV";
			repo = "bars.nvim";
			rev = "3a61a25";
			hash = "sha256-pkuPzIppRzx5pn0roKExNK4NQUBwqom/g1hLA6KeuSM=";
		};
	}
