{config, pkgs, ...}: {
	programs.nixvim = {
		extraPlugins = [
			# {
			# 	plugin = pkgs.vimPlugins.tabby-nvim;
			# 	optional = true;
			# }
			{
				plugin = pkgs.vimUtils.buildVimPlugin {
					pname = "bars-nvim";
					version = "latest-2025-12";
					src = pkgs.fetchFromGitHub {
					  owner = "OXY2DEV";
					  repo = "bars.nvim";
					  rev = "3a61a25";
					  hash = "sha256-pkuPzIppRzx5pn0roKExNK4NQUBwqom/g1hLA6KeuSM=";
					};
				};
				optional = false;
			}
		];
		extraConfigLua = ''
if true then
	require('bars').setup {
		tabline = false,
		winbar = false,
		statuscolumn = false,
		statusline = false,
	}
	local tabline = require('bars.tabline')
	local winbar = require('bars.winbar')
	local statuscolumn = require('bars.statuscolumn')
	local statusline = require('bars.statusline')

	${builtins.readFile ./bars/statusline-setup.lua}
	${builtins.readFile ./bars/tabline-setup.lua}

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
	require('bars').setup {
		tabline = true,
		statuscolumn = true,
		statusline = true,
		winbar = false,
	}
end
-- require('lz.n').load {
-- 	'tabby.nvim',
-- 	event = "DeferredUIEnter",
-- 	after = function()
-- 		require('tabby').setup {
-- 			preset = "tab_only",
-- 			option = {
-- 				lualine_theme = _G.get_lualine_name(),
-- 				nerdfont = true,
-- 			},
-- 		}
-- 	end
-- }

		'';
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
