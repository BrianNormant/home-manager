{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "gitgraph";
	package = "gitgraph-nvim";
	maintainers = [];
	description = "A git log graph plugin for neovim";
	moduleName = "gitgraph";
}
