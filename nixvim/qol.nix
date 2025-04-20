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
					map_cr = false;
				};
			};
			nvim-surround = {
				enable = true;
				lazyLoad.settings = { event = "DeferredUIEnter"; };
				settings = {};
			};
			undotree = {
				enable = true;
				# lazyLoad.settings = { cmd = "UndotreeToggle"; };
				settings = {
					WindowLayout = 3;
				};
			};
		};
		keymaps = [
			{
				key = "<a-u>";
				action = "<CMD>UndotreeToggle<CR>";
				options.desc = "Toggle undotree";
			}
		];
	};
}
