{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			toggleterm = {
				enable = true;
				lazyLoad.settings = {
					key = [
						{
							__unkeyed-1 = "<leader>tt";
							__unkeyed-2.__raw = ''
								function() require("toggleterm.terminal").toggle() end
							'';
						}
					];
				};
			};
		};
	};
}
