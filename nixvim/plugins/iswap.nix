{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "iswap";
	package = "iswap-nvim";
	maintainers = [];
	description = "Interactively select and swap function arguments, list items, and more";
	moduleName = "iswap";
}
