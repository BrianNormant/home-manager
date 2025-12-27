{config, pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			bars = {
				enable = true;
				package = pkgs.vimPlugins.bars-nvim.overrideAttrs {
					patches = [
						./plugin-patch/bars-nvim.patch
					];
				};
				settings = {
					statusline = true;
					statuscolumn = true;
					tabline = false;
					winbar = false;
				};
				luaConfig.pre = ''
local tabline = require('bars.tabline')
local winbar = require('bars.winbar')
local statuscolumn = require('bars.statuscolumn')
local statusline = require('bars.statusline')

${builtins.readFile ./bars/statusline-setup.lua}

statuscolumn.setup {
	ignore_filetypes = {
		"TelescopePrompt",
		"oil",
	},
}
winbar.setup {
	ignore_filetypes = {
		"TelescopePrompt",
		"toggleterm",
		"oil",
	},
	ignore_buftypes = {
		"nowrite",
		"nofile",
		"quickfix",
		"help",
		"prompt",
		"",
		"acwrite",
		"terminal",
	};
}
'';
			};
		};
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
