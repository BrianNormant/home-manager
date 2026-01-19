{pkgs, ... }:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;

in {
	programs.nixvim = {
		plugins = {
			friendly-snippets.enable = true;
		};
		extraConfigLuaPre = ''
			_G.friendly_snippets_path = "${pkgs.vimPlugins.friendly-snippets}"
		'';
		extraConfigLuaPost = builtins.readFile ./completion.lua;
		keymaps = [ ];
	};
}
