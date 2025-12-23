{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "gitgraph.nvim";
		version = "23/12/2025";
		src = fetchFromGitHub {
			owner = "isakbm";
			repo = "gitgraph.nvim";
			rev = "c16daa7";
			hash = "sha256-QQcqLUJIligXW9bGQR1sDmg9efNFuTWQGCk7E9ni8Tc=";
		};
	}
