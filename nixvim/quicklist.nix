{pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			quicker.enable = true;
			nvim-bqf.enable = true;
			nvim-bqf.extraOptions = {
				preview = {
					border = "double";
					show_scroll_bar = false;
					winblend = 0;
				};
			};
		};
	};
}
