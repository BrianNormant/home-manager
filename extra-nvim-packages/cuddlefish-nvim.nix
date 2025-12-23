{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "cuddlefish.nvim";
		version = "6448a5f";
		src = fetchFromGitHub {
			owner = "comfysage";
			repo = "cuddlefish.nvim";
			rev = "6448a5f";
			hash = "sha256-ZZ5kE/MikATxbtmhoXYvkxRaIgseCDAkfZse4NaWoes=";
		};
		nvimSkipModules = [
			"cuddlefish.extras"
		];
	}
