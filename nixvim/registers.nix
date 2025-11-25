{pkgs, ... }:
let
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		plugins = {
			marks = {
				enable = true;
				lazyLoad.settings = { event = "DeferredUIEnter"; };
			};
		};
		extraPlugins = with vimPlugins; [
			{
				plugin = registers-nvim;
				optional = true;
			}
		];
		extraConfigLua = builtins.readFile ./registers.lua;
	};
}
