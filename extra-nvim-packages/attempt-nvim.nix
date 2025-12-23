{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "attempt-nvim";
		src = fetchFromGitHub {
			owner = "m-demare";
			repo = "attempt.nvim";
			rev = "ab5137f";
			hash = "sha256-/2CstagRnBk3sz+4bCawRZ1jvACWvry/PEbNQhjI4Bs=";
		};
		buildInputs = with pkgs.vimPlugins; [
			plenary-nvim
		];
		nvimSkipModules = [
			"attempt.interface"
			"attempt.filedata"
			"attempt.manager"
		];
	}
