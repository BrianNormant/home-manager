{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "nvim-better-n";
	package = "nvim-better-n";
	maintainers = [];
	description = "Repeatable motions";
	moduleName = "better-n";
}
