{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "undo-glow";
	package = "undo-glow-nvim";
	maintainers = [];
	description = ''
undo-glow.nvim is a Neovim plugin that adds beautiful visual feedback to your edits. See exactly what changed when you undo, redo, paste, search, or perform any text operation.
	'';
	moduleName = "undo-glow";
}
