{pkgs, ... }:
let
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		extraPlugins = with vimPlugins; [
			{
				plugin = boole-nvim;
				optional = true;
			}
			{
				plugin = vim-wakatime;
				optional = false;
			}
		];
		extraConfigLua = builtins.readFile ./boole.lua;
		plugins = {
			nvim-autopairs = {
				enable = true;
				lazyLoad.settings = { event = "DeferredUIEnter"; };
				settings = {
					map_c-w = true;
				};
			};
			nvim-surround = {
				enable = true;
				lazyLoad.settings = { event = "DeferredUIEnter"; };
				settings = {};
			};
		};
	};
}
