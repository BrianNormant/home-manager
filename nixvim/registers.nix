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
				plugin = registers-nvim.overrideAttrs {
					patches = [
						./plugin-patch/registers-nvim.patch
					];
				};
				optional = true;
			}
		];
		extraConfigLua = builtins.readFile ./registers.lua;
	};
}
