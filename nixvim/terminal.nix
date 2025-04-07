{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			toggleterm = {
				enable = true;
				settings = {
					direction = "float";
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
