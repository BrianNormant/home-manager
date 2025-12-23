{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "registers";
	package = "registers-nvim";
	maintainers = [];
	description = "Persistent and synced registers";
	moduleName = "registers";
}
