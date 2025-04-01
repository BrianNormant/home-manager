{config, pkgs, ...}: {
	programs.nixvim = {
		plugins.mini = {
			enable = true;
			luaConfig.post = builtins.readFile ./mini.lua;
			modules = {
				ai = {};
				align = {};
				comment = {};
				move = {};
				operators = {};
				pairs = {};
				surround = {};
				bracketed = {};
				cursorword = {};
				notify = {
					lsp_progress.enable = false;
				};
				animate = {
					cursor.enable = false;
					scroll.enable = false;
					resize.enable = true;
					open.enable = true;
					close.enable = true;
				};
			};
		};
	};
}
