{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "boole";
	package = "boole-nvim";
	maintainers = [];
	description = "Boolean logic in Neovim";
	moduleName = "boole";
}
