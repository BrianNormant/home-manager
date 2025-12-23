{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "nvim-better-n";
		src = fetchFromGitHub {
			owner = "jonatan-branting";
			repo = "nvim-better-n";
			rev = "95d8ce2";
			hash = "sha256-Y/b7iXXQw9hbZ2uAkcJNuKt30pn2Vdsk/IOjBJ3QjAM=";
		};
		buildInputs = with pkgs.vimPlugins; [
			nvim-treesitter
		];
		nvimSkipModules = [
			"nvim-better-n"
		];
	}
