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
				"<leader>ff" = {
					action = "find_files";
					options.desc = "Telescope: Find Files";
				};
				"<leader>fF" = {
					action = "live_grep";
					options.desc = "Telescope: Live Grep";
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
		};
	};
}
