{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "telepath";
	package = "telepath-nvim";
	maintainers = [];
	description = "A plugin for managing telescope";
	moduleName = "telescope";
	hasLuaConfig = true;
	callSetup = false;
}
