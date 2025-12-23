{ pkgs, ...}:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
in {
	programs.nixvim = {};
}
