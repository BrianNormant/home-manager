{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "various-textobjs";
	package = "nvim-various-textobjs";
	maintainers = [];
	description = "Various text objects";
	moduleName = "various-textobjs";
}
