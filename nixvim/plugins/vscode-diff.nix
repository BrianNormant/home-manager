{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "vscode-diff";
	package = "vscode-diff-nvim";
	maintainers = [];
	description = "Visual Studio Code-like diff";
	moduleName = "vscode-diff";
}
