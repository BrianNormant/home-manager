{pkgs, ...}: {
	programs.nixvim = {
		plugins.nvim-ufo = {
			enable = true;
			settings = {
				provider_selector = ''
				function()
					return {'treesitter', 'indent'}
				end
				'';
				enable_get_fold_virt_text = true;
				fold_virt_text_handler = builtins.readFile ./ufo-text-handler.lua;
			};
			lazyLoad.settings = {
				event = ["DeferredUIEnter"];
			};
		};
		globalOpts = {
			foldcolumn     = "0";
			foldlevel      = 99;
			foldlevelstart = 99;
			foldenable     = true;
		};
	};
}
