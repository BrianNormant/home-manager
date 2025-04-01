{config, pkgs, ...}: {
	programs.nixvim = {
		plugins.gitsigns = {
			enable = true;
			lazyLoad.settings = {
				event = [ "DeferredUIEnter" ];
			};
			luaConfig.post = builtins.readFile ./gitsigns.lua;
		};
	};
}
