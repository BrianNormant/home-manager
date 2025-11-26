{pkgs, lib, ... }: {
	programs.nixvim = {
		plugins = {
			idris2 = {
				enable = true;
				settings = {
					code_action_post_hook.__raw = ''
						function(_)
							vim.cmd "silent write"
						end
					'';
				};
				lazyLoad = {
					enable = true;
					settings = {
						ft = "idris2";
					};
				};
			};
		};
	};
}
