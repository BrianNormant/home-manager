{_, ...}:
{
	programs.nixvim = {
		keymaps = [
			{
				key = "<leader>tt";
				action = "<cmd>tab term<CR>";
			}
			{
				key = "|";
				action = "<cmd>vsplit<cr>";
				options.desc = "Split Vertical";
			}
			{
				key = "\\";
				action = "<cmd>split<cr>";
				options.desc = "Split Horizontal";
			}
			{
				key = "z=";
				action.__raw = ''
				function()
					require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor())
				end
				'';
				options.desc = "Telescope: SpellCheck";
			}
			{
				key = "<S-Up>";
				action = "<Up>";
				options.nowait = true;
			}
			{
				key = "<S-Down>";
				action = "<Down>";
				options.nowait = true;
			}
			{
				key = "<A-/>";
				action = "<cmd>noh<cr>";
				options.desc = "Supress search highlight";
			}
			{
				key = "gf";
				action = ":e <cfile><CR>";
				options.desc = "Open/Create File";
			}
		];
	};
}
