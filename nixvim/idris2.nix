{pkgs, ... }: {
	programs.nixvim = {
		plugins.idris2 = {
			enable = true;
			settings = {
				code_action_post_hook.__raw = ''
				function(_)
					vim.cmd "silent write"
				end
				'';
			};
			lazyLoad.enable = false;
			lazyLoad.settings = {
				ft = [ "idris2" ];
			};
		};
	};
}
