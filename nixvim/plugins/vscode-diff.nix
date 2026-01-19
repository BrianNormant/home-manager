{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "codediff";
	package = "codediff-nvim";
	maintainers = [];
	description = "Visual Studio Code-like diff";
	moduleName = "codediff";
}
