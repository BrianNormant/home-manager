{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "hover";
	package = "hover-nvim";
	maintainers = [];
	description = "Hover plugin for Neovim";
	moduleName = "hover";
}
