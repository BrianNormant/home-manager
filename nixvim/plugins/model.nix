{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "model";
	package = "model-nvim";
	maintainers = [];
	moduleName = "model";
}
