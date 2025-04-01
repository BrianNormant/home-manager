{config, pkgs, ...}: {
	programs.nixvim = {
		plugins.lualine = {
			enable = true;
			lazyLoad.settings = {
				event = [ "DeferredUIEnter" ];
			};
			luaConfig.post = builtins.readFile ./lualine.lua;
		};
	};
}
