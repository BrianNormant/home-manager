{config, pkgs, ...}: {
	programs.nixvim = {
		extraPlugins = [
			{
				plugin = pkgs.vimPlugins.tabby-nvim;
				optional = true;
			}
		];
		extraConfigLua = builtins.readFile ./tabby.lua;
		keymaps = [
			{
				key = "<A-1>";
				action = "<cmd>1tabnext<CR>";
				options.desc = "Open tab at index 1";
			}
			{
				key = "<A-2>";
				action = "<cmd>2tabnext<CR>";
				options.desc = "Open tab at index 2";
			}
			{
				key = "<A-3>";
				action = "<cmd>3tabnext<CR>";
				options.desc = "Open tab at index 3";
			}
			{
				key = "<A-4>";
				action = "<cmd>4tabnext<CR>";
				options.desc = "Open tab at index 4";
			}
			{
				key = "<A-5>";
				action = "<cmd>5tabnext<CR>";
				options.desc = "Open tab at index 5";
			}
			{
				key = "<A-6>";
				action = "<cmd>6tabnext<CR>";
				options.desc = "Open tab at index 6";
			}
			{
				key = "<A-7>";
				action = "<cmd>7tabnext<CR>";
				options.desc = "Open tab at index 7";
			}
			{
				key = "<A-8>";
				action = "<cmd>8tabnext<CR>";
				options.desc = "Open tab at index 8";
			}
			{
				key = "<A-9>";
				action = "<cmd>9tabnext<CR>";
				options.desc = "Open tab at index 9";
			}
			{
				key = "<leader>ta";
				action = "<cmd>$tabnew<CR>";
				options.desc = "Open new tab";
			}
			{
				key = "<M-t>";
				action = "<cmd>Tabby jump_to_tab<CR>";
				options.desc = "Leap to Tab";
			}
			{
				key = "<leader>tq";
				action = "<cmd>tabclose<CR>";
				options.desc = "Close current tab";
			}
			{
				key = "<leader>tQ";
				action = "<cmd>tabonly<CR>";
				options.desc = "Close all other tab";
			}
			{
				key = "<leader>tmp";
				action = "<cmd>-tabmove<CR>";
				options.desc = "Move current tab left <-- ";
			}
			{
				key = "<leader>tmn";
				action = "<cmd>+tabmove<CR>";
				options.desc = "Move current tab right -->";
			}
		];
	};
}
