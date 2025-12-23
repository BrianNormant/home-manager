{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "bars";
	package = "bars-nvim";
	maintainers = [];
	description = "A statusline/tabline plugin for neovim";
	moduleName = "bars";
}

