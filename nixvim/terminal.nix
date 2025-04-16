{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			toggleterm = {
				enable = true;
				settings = {
					direction = "float";
					float_opts = {
						winblend = 50;
					};
				};
				lazyLoad.settings = {
					keys = [
						{
							__unkeyed-1 = "<leader>tt";
							__unkeyed-2 = "<CMD>ToggleTerm<CR>";
						}
					];
				};
			};
		};
	};
}
