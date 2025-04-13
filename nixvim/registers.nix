{pkgs, ... }:
let
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		extraPlugins = with vimPlugins; [
			{
				plugin = registers-nvim;
				optional = true;
			}
			{
				plugin = marks-nvim;
				optional = true;
			}
		];
		extraConfigLua = builtins.readFile ./registers.lua;
	};
}
