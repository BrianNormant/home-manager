{config, pkgs, ...}: {
	programs.nixvim = {
		plugins.diffview = {
			enable = true;
			# lazyLoad.settings = {
			# 	keys = [ {
			# 		__unkeyed-1 = "<F2>";
			# 		__unkeyed-3 = "<cmd>DiffviewOpen<cr>";
			# 		desc = "Open Diffview";
			# 	} ];
			# 	cmd = "DiffviewOpen";
			# };
		};
	};
}
