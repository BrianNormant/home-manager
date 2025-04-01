{config, pkgs, ...}: {
	programs.nixvim = {
		plugins.gitsigns = {
			enable = true;
			lazyLoad.settings = {
				event = [ "DeferredUIEnter" ];
			};
			luaConfig.content = builtins.readFile ./gitsigns.lua;
		};
	};
}
