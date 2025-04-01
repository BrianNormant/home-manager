{config, pkgs, ...}: {
	programs.nixvim = {
		colorscheme = "gruvbox-material";
		extraPlugins = [ pkgs.vimPlugins.gruvbox-material-nvim ];
		extraConfigLua = builtins.readFile ./gruvbox.lua;
	};
}
