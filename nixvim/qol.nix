{config, pkgs, ...}: {
	programs.nixvim = {
		extraPlugins = [ pkgs.vimPlugins.boole-nvim ];
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
