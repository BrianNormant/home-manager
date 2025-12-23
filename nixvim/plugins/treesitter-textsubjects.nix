{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "treesitter-textsubjects";
	package = "nvim-treesitter-textsubjects";
	maintainers = [];
	description = "Treesitter based text objects";
	moduleName = "nvim-treesitter-textsubjects";
}
