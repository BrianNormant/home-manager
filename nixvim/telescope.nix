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
			settings = {
				defaults.__raw = ''
					vim.tbl_extend(
						"force",
						require("telescope.themes").get_dropdown(),
						{}
					)
				'';
			};
		};
		keymaps = [
			# Frecency
			{
				key = "<leader>ff";
				action = "<Cmd>Telescope frecency workspace=CWD<CR>";
				options.desc = "Telescope: Find Files Frecency";
			}
			{
				key = "<leader>F";
				action = "<Cmd>Telescope find_files<CR>";
				options.desc = "Telescope: Find Files";
			}
			{
				key = "<leader>fF";
				action = "<CMD>Telescope live_grep_args<cr>";
				options.desc = "Telescope: Live Grep";
			}
		];
	};
}
