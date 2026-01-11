{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in vimUtils.buildVimPlugin rec {
		name = "undo-glow-nvim";
		version = "1.13.0";
		src = fetchFromGitHub {
			owner = "y3owk1n";
			repo = "undo-glow.nvim";
			rev = "v${version}";
			hash = "sha256-TpZlObtK+tasaGEDuQBcs7QdHzcM7LAnKD2oficFEF0=";
		};
	}
