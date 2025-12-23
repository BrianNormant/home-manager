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
			hash = "sha256-d55IRrOhK5tSLo2boSuMhDbkerqij5AHgNDkwtGadyI=";
		};
		patches = [ ../nixvim/plugin-patch/gitgraph.patch ];
	}
