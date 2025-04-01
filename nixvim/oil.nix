{pkgs, ...}: {
	programs.nixvim = {
		plugins.oil = {
			enable = true;
			settings = {
				experimental_watch_for_changes = true;
				skip_confirm_for_simple_edits = true;
			};
		};
		keymaps = [
			{
				key = "<leader>oo";
				action = "<cmd>Oil --float<cr>";
				options.desc = "Oil in Float";
			}
			{
				key = "<leader>oO";
				action = "<cmd>Oil<cr>";
				options.desc = "Oil in current window";
			}
		];
	};
}
