{config, pkgs, ...}: {
	programs.nixvim = {
		extraPlugins =
			if config.nixvim.colorscheme == "gruvbox" then
				[ pkgs.vimPlugins.gruvbox-material-nvim ]
			else if config.nixvim.colorscheme == "cuddlefish" then
				[ (pkgs.vimUtils.buildVimPlugin rec {
					pname = "cuddlefish.nvim";
					version = "6448a5f";
					src = pkgs.fetchFromGitHub{
						owner = "comfysage";
						repo = pname;
						rev = version;
						hash = "sha256-ZZ5kE/MikATxbtmhoXYvkxRaIgseCDAkfZse4NaWoes=";
					};
					nvimSkipModules = [
						"cuddlefish.extras"
					];
				}) ]
			else abort "${config.nixvim.colorscheme} is not a valid colorscheme";
		
		extraConfigLua =
			if config.nixvim.colorscheme == "gruvbox" then
				builtins.readFile ./gruvbox.lua
			else if config.nixvim.colorscheme == "cuddlefish" then
				builtins.readFile ./cuddlefish.lua
			else abort "${config.nixvim.colorscheme} is not a valid colorscheme";

		extraConfigLuaPre = builtins.readFile ./snippets.lua;
		plugins = {
			colorizer = {
				enable = true;
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
			};
		};
		# highlightOverride = {
		# 	NormalFloat = {
		# 		fg      = "#d4be98";
		# 		bg      = "#32302f";
		# 	};
		# 	FloatBorder = {
		# 		fg      = "#928374";
		# 		bg      = "#32302f";
		# 	};
		# 	FloatTitle = {
		# 		fg      = "#e78a4e";
		# 		bg      = "#32302f";
		# 		bold    = true;
		# 	};
		# };
		colorscheme =
			if config.nixvim.colorscheme == "gruvbox" then
				"gruvbox-material"
			else if config.nixvim.colorscheme == "cuddlefish" then
				"cuddlefish"
			else abort "${config.nixvim.colorscheme} is not a valid colorscheme";
	};
}
