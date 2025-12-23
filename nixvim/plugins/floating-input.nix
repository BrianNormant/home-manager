{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "floating-input";
	package = "floating-input-nvim";
	maintainers = [];
	description = "Floating input for Neovim";
	moduleName = "floating-input";
}
