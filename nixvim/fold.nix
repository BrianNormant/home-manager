{pkgs, ...}: {
	programs.nixvim = {
		plugins.origami = {
			enable = true;
			settings = {
				autoFold = {
					enabled = false;
				};
				foldKeymaps = {
					setup = false;
				};
			};
			lazyLoad.settings = {
				event = ["DeferredUIEnter"];
			};
		};
		globalOpts = {
			# foldcolumn     = "0";
			# foldenable     = true;
			foldlevel      = 99;
			foldlevelstart = 99;
		};
	};
}
