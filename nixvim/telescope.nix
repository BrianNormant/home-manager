{pkgs, ... }:
{
	programs.nixvim = {
		plugins.telescope = {
			enable = true;
			keymaps = {
				"<leader>ft" = {
					action = "builtin";
					options.desc = "Telescope: Builtins";
				};
				"<leader>fb" = {
					action = "buffers";
					options.desc = "Telescope: Buffers";
				};
				"<leader>f/" = {
					action = "current_buffer_fuzzy_find";
					options.desc = "Telescope: Live Grep Buffer";
				};
				"<leader>fh" = {
					action = "help_tags";
					options.desc = "Telescope: Search Help";
				};
				"<leader>fk" = {
					action = "keymaps";
					options.desc = "Telescope: Search Keymaps";
				};
				"<leader>fm" = {
					action = "man_pages";
					options.desc = "Telescope: Search Man Pages";
				};
			};
			extensions = {
				advanced-git-search.enable = true;
				frecency = {
					enable = true;
					settings = {
						default_workspace = "CWD";
					};
				};
				fzf-native = {
					enable = true;
					settings = {
						case_mode = "ignore_case";
						fuzzy = true;
						override_generic_sorter = true;
						override_file_sorter = true;
					};
				};
				live-grep-args = {
					enable = true;
				};
			};
			lazyLoad.settings = {
				keys = [
					{__unkeyed-1 = "<leader>ft";}
					{__unkeyed-1 = "<leader>fb";}
					{__unkeyed-1 = "<leader>f/";}
					{__unkeyed-1 = "<leader>fh";}
					{__unkeyed-1 = "<leader>fk";}
					{__unkeyed-1 = "<leader>fm";}
				];
				cmd = [
					"Telescope"
					"AdvancedGitSearch"
				];
			};
		};
		keymaps = [
			# Frecency
			{
				key = "<leader>ff";
				action = "<Cmd>Telescope frecency<CR>";
				options.desc = "Telescope: Find Files Frecency";
			}
			# advanced git search
			{
				key = "<leader>fg";
				action = "<Cmd>AdvancedGitSearch diff_commit_file<CR>";
				options.desc = "Telescope Git: Diff current file with <commits>";
			}
			{
				key = "<leader>fg";
				action = "<Cmd>AdvancedGitSearch diff_commit_line<CR>";
				options.desc = "Telescope Git: Diff current range with <commits>";
				mode = [ "v" ];
			}
			{
				key = "<leader>fG";
				action = "<Cmd>AdvancedGitSearch show_custom_functions<CR>";
				options.desc = "Telescope Git: Show custom functions";
			}
			{
				key = "<leader>fF";
				action = "<CMD>Telescope live_grep_args<cr>";
				options.desc = "Telescope: Live Grep";
			}
			{
				key = "<leader>fn";
				action = "<CMD>Telescope manix<cr>";
				options.desc = "Telescope: Nix Help";
			}
		];
	};
}
