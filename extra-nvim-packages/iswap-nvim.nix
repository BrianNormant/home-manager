{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "iswap-nvim";
		src = fetchFromGitHub {
			owner = "mizlan";
			repo = "iswap.nvim";
			rev = "e02cc91";
			hash = "sha256-lAYHvz23f9nJ6rb0NIm+1aq0Vr0SwjPVitPuROtUS2A=";
		};
		buildInputs = with pkgs.vimPlugins; [
			nvim-treesitter
		];
	}
