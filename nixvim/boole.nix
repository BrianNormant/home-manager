{config, pkgs, ...}: {
	programs.nixvim = {
		extraPlugins = [ pkgs.vimPlugins.boole-nvim ];
		extraConfigLua = builtins.readFile ./boole.lua;
	};
}
