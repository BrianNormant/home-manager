{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "outline";
	package = "outline-nvim";
	maintainers = [];
	description = "Outline plugin for Neovim";
	moduleName = "outline";
}
