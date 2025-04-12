{pkgs, ... }:
{
	programs.nixvim = {
		plugins.telescope = {
			enable = true;
			extensions = {
				frecency = { enable = true; };
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
				ui-select = {
					enable = true;
					settings.__raw =''
						require('telescope.themes').get_ivy {}
					'';
				};
			};
			lazyLoad.settings = {
				event = "DeferredUIEnter";
			};
		};
		keymaps = [
			# Frecency
			{
				key = "<leader>ff";
				action = "<Cmd>Telescope frecency workspace=CWD theme=dropdown<CR>";
				options.desc = "Telescope: Find Files Frecency";
			}
			{
				key = "<leader>F";
				action = "<Cmd>Telescope find_files theme=dropdown<CR>";
				options.desc = "Telescope: Find Files";
			}
			{
				key = "<leader>fF";
				action = "<CMD>Telescope live_grep_args theme=dropdown<cr>";
				options.desc = "Telescope: Live Grep";
			}
			{
				key = "<leader>ft";
				action = "<CMD>Telescope builtin theme=dropdown<CR>";
				options.desc = "Telescope: Builtins";
			}
			{
				key = "<leader>fb";
				action = "<CMD>Telescope buffers theme=dropdown<CR>";
				options.desc = "Telescope: Buffers";
			}
			{
				key = "<leader>f/";
				action = "<CMD>Telescope current_buffer_fuzzy_find theme=ivy<CR>";
				options.desc = "Telescope: Live Grep Buffer";
			}
			{
				key = "<leader>fh";
				action = "<CMD>Telescope help_tags theme=ivy<CR>";
				options.desc = "Telescope: Search Help";
			}
			{
				key = "<leader>fk";
				action = "<CMD>Telescope keymaps theme=ivy<CR>";
				options.desc = "Telescope: Search Keymaps";
			}
			{
				key = "<leader>fm";
				action = "<CMD>Telescope man_pages theme=ivy<CR>";
				options.desc = "Telescope: Search Man Pages";
			}
			{
				key = "<leader>fi";
				action = "<CMD>Telescope lsp_incoming_calls theme=ivy<CR>";
				options.desc = "Telescope: LSP Incoming Calls";
			}
			{
				key = "<leader>fo";
				action = "<CMD>Telescope lsp_outgoing_calls theme=ivy<CR>";
				options.desc = "Telescope: LSP Outgoing Calls";
			}
		];
	};
}
