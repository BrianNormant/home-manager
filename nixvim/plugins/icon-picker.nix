{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "icon-picker";
	package = "icon-picker-nvim";
	maintainers = [];
	description = "Icon picker for Neovim";
	moduleName = "icon-picker";
}
