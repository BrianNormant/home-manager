{config, pkgs, ...}: {
	programs.nixvim = {
		extraPackages = with pkgs; [
			figlet
		];
		plugins.mini = {
			enable = true;
			luaConfig.post = builtins.readFile ./mini.lua;
			modules = {
				ai = {};
				align = {};
				comment = {};
				move = {};
				operators = {
					evaluate.prefix = "g=";
					exchange.prefix = "gx";
					multiply.prefix = "gm";
					replace.prefix  = "sp";
					sort.prefix     = "gs";
				};
				pairs = {};
				surround = {};
				bracketed = {};
				cursorword = {};
				notify = {
					lsp_progress.enable = false;
				};
				animate = {
					cursor.enable = false;
					scroll.enable = false;
					resize.enable = true;
					open.enable = true;
					close.enable = true;
				};
				starter = {
					header.__raw = ''
						function()
							local text = "nixvim"
							local font = "starwars"

							if (vim.env.PROJECT) then
								text = vim.env.PROJECT
							end

							local figlet = vim.system({'figlet', '-t', '-c', '-f', font, text }, {text=true}):wait()
							return figlet.stdout
						end
					'';
					items.__raw = ''
						{
							function()
								return {
									{ action = 'Telescope find_files',   name = 'Files',        section = "Telescope" },
									{ action = 'Telescope git_files',    name = 'Git Files',    section = "Telescope" },
									{ action = 'Telescope git_commits',  name = 'Git Commits',  section = "Telescope" },
									{ action = 'Telescope git_branches', name = 'Git Branches', section = "Telescope" },
									{ action = 'Telescope git_stash',    name = 'Git Stash',    section = "Telescope" },
									{ action = 'Telescope help_tags',    name = 'Help',         section = "Telescope" },
									{ action = 'Telescope colorscheme',  name = 'ColorScheme',  section = "Telescope" },
									{ action = 'Telescope keymaps',      name = 'Keymaps',      section = "Telescope" },
								}
							end,
							function()
								return {
									{ action = "Git",        name = "Git",        section = "Fugitive" },
									{ action = "Git commit", name = "Git Commit", section = "Fugitive" },
									{ action = "Git pull",   name = "Git Pull",   section = "Fugitive" },
									{ action = "Git push",   name = "Git Push",   section = "Fugitive" },
									{ action = "Git stash",  name = "Git stash",  section = "Fugitive" },
								}
							end,
							require('mini.starter').sections.builtin_actions(),
						}
					'';
				};
			};
		};
		highlightOverride = {
			MiniCursorword = { underline = true; };
			MiniCursorwordCurrent = { underline = true; };
		};
	};
}
