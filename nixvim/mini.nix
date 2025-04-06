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
									{ action = 'Telescope live_grep',    name = 'LGrep',        section = "Telescope" },
									{ action = 'Telescope oldfiles',     name = 'Recent Files', section = "Telescope" },
									{ action = 'Telescope git_files',    name = 'FFiles Git',   section = "Telescope" },
									{ action = 'Telescope git_commits',  name = 'FCommits',     section = "Telescope" },
									{ action = 'Telescope git_branches', name = 'FBranches',    section = "Telescope" },
									{ action = 'Telescope git_stash',    name = 'FStash',       section = "Telescope" },
									{ action = 'Telescope help_tags',    name = 'Help',         section = "Telescope" },
									{ action = 'Telescope colorscheme',  name = 'ColorScheme',  section = "Telescope" },
									{ action = 'Telescope keymaps',      name = 'Keymaps',      section = "Telescope" },
								}
							end,
							function()
								return {
									{ action = "Git",        name = "Git",           section = "Fugitive" },
									{ action = "Git log",    name = "Log (Git log)", section = "Fugitive" },
									{ action = "Git commit", name = "Commit",        section = "Fugitive" },
									{ action = "Git pull",   name = "Pull",          section = "Fugitive" },
									{ action = "Git push",   name = "Push",          section = "Fugitive" },
									{ action = "Git stash",  name = "Stash",         section = "Fugitive" },
								}
							end,
							function ()
								return {
									{ action = "Oil", name=  "Oil", section = "Other" },
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
