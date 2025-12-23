{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "icon-picker.nvim";
		version = "3ee9a0e";
		src = fetchFromGitHub {
			owner = "ziontee113";
			repo = "icon-picker.nvim";
			rev = "3ee9a0e";
			sha256 = "VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
		};
	}
