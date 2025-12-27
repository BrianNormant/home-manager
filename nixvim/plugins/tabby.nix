{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "tabby";
	package = "tabby-nvim";
	maintainers = [];
	description = "True Tabline plugin";
	moduleName = "tabby";
}
