{ pkgs, ...}: {
	programs.nixvim = {
		extraPackages = with pkgs; [
			figlet
		];
		plugins.mini = {
			enable = true;
			luaConfig = {
				pre = ''
					_G.minicursorword_disable = function()
						local ft = vim.bo.filetype
						local disable = (
								ft == 'git' or
								ft == 'fugitive' or
								ft == 'help' or
								ft == 'man' or
								ft == 'gitgraph'
								)
						vim.b.minicursorword_disable = disable
					end
					vim.cmd "au BufEnter * lua _G.minicursorword_disable()"
				'';
				post = builtins.readFile ./mini.lua;
			};
			modules = {
				extra = {};
				# sessions = { autoread = true; };
				ai = {
					custom_textobjects = {
						# Full buffer
						g.__raw = ''
							function()
								local from = { line = 1, col = 1 }
								local to = {
									line = vim.fn.line('$'),
									col = math.max(vim.fn.getline('$'):len(), 1)
								}
								return { from = from, to = to }
							end
						'';
						I.__raw = ''require('mini.extra').gen_ai_spec.indent()'';
						L.__raw = ''require('mini.extra').gen_ai_spec.line()'';
						N.__raw = ''require('mini.extra').gen_ai_spec.number()'';
					};
				};
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
				bracketed = {
					diagnostic.options.severity = 1; #"vim.diagnostic.severity.ERROR";
				};
				cursorword = { delay = 500; };
				notify = {
					lsp_progress.enable = false;
				};
				starter = {
					header.__raw = ''
						function()
							local text = "nixvim"
							local font = "starwars"

							if (vim.env.PROJECT) then
								text = vim.env.PROJECT
							end

							local figlet = vim.system({'figlet', '-w', 80, '-c', '-f', font, text }, {text=true}):wait()
							return figlet.stdout
						end
					'';
					items.__raw = ''
						{
							function()
								return {
									{ action = 'Telescope frecency workspace=CWD theme=dropdown', name = 'Files',       section = "Telescope" },
									{ action = 'Telescope live_grep theme=dropdown',              name = 'LGrep',       section = "Telescope" },
									{ action = 'Telescope git_files theme=dropdown',              name = 'FFiles Git',  section = "Telescope" },
									{ action = 'Telescope git_commits theme=dropdown',            name = 'FCommits',    section = "Telescope" },
									{ action = 'Telescope git_branches theme=dropdown',           name = 'FBranches',   section = "Telescope" },
									{ action = 'Telescope git_stash theme=dropdown',              name = 'FStash',      section = "Telescope" },
									{ action = 'Telescope help_tags theme=dropdown',              name = 'Help',        section = "Telescope" },
									{ action = 'Telescope colorscheme theme=ivy',                 name = 'ColorScheme', section = "Telescope" },
									{ action = 'Telescope keymaps theme=ivy',                     name = 'Keymaps',     section = "Telescope" },
								}
							end,
							function()
								return {
									{ action = "Git",        name = "Status",           section = "Git" },
									{ action = function()
										require('gitgraph').draw({}, {all = true, max_count = 100})
									end,    name = "Log (Git log)", section = "Git" },
									{ action = "Git commit", name = "Commit",        section = "Git" },
									{ action = "Git pull",   name = "Pull",          section = "Git" },
									{ action = "Git push",   name = "Push",          section = "Git" },
									{ action = "Git stash",  name = "Stash",         section = "Git" },
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
			MiniCursorword = { bold = true; };
			MiniCursorwordCurrent = { bold = true; };
			MiniOperatorsExchangeFrom = { bg = "#d79921"; bold=true; };
		};
	};
}
