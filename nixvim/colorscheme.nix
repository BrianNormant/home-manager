{config, pkgs, ...}: {
	programs.nixvim = {
		colorscheme = "gruvbox-material";
		extraPlugins = [ pkgs.vimPlugins.gruvbox-material-nvim ];
		extraConfigLua = builtins.readFile ./gruvbox.lua;
		extraConfigLuaPre = builtins.readFile ./snippets.lua;
		plugins = {
			colorizer = {
				enable = true;
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
			};
		};
		highlightOverride = {
			NormalFloat = {
				fg      = "#d4be98";
				bg      = "#32302f";
			};
			FloatBorder = {
				fg      = "#928374";
				bg      = "#32302f";
			};
			FloatTitle = {
				fg      = "#e78a4e";
				bg      = "#32302f";
				bold    = true;
			};
		};
	};
}
