{pkgs, ... }:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.lib) fakeHash;
	inherit (pkgs) fetchFromGitHub;

in {
	programs.nixvim = {
		plugins = {
			friendly-snippets.enable = true;
			wilder = { enable = true; };
		};
		extraPlugins = with pkgs.vimPlugins; [
			{
				plugin = supermaven-nvim.overrideAttrs {
					patches = [
						./plugin-patch/supermaven.patch
					];
				};
				optional = true;
			}
			{
				plugin = buildVimPlugin rec {
					pname = "compl.nvim";
					version = "3fe5dd7";
					src = fetchFromGitHub {
						owner = "brianaung";
						repo = pname;
						rev = version;
						hash = "sha256-XrFNPYr4XcfcVG6QiQdplBGyy+dAHYsQfVOxLR7TQv8=";
					};
					patches = [
						./plugin-patch/compl.nvim.patch
					];
				};
				optional = true;
			}
		];
		extraConfigLuaPre = ''
			_G.friendly_snippets_path = "${pkgs.vimPlugins.friendly-snippets}"
		'';
		extraConfigLuaPost = builtins.readFile ./completion.lua;
	};
}
