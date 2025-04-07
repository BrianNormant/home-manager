{config, pkgs, ...}: {
	programs.nixvim = {
		colorscheme = "gruvbox-material";
		extraPlugins = [ pkgs.vimPlugins.gruvbox-material-nvim ];
		extraConfigLua = builtins.readFile ./gruvbox.lua;
		plugins = {
			colorizer = {
				enable = true;
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
			};
			smartcolumn = {
				enable = false;
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
				settings = {
					colorcolumn = "80";
					disabled_filetype = [ "help" "ministarter" ];
					custom_colorcolumn = {
						lua = "100";
						nix = "100";
						java = "100";
					};
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
