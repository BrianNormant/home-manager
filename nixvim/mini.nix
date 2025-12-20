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
			mockDevIcons = true;
			modules = {
				extra = {};
				sessions = {
					autowrite = true;
					# Does it only load the local session,
					# Or the last loaded session?
					autoread  = false;
					hooks = {
						post = {
							read.__raw = ''function()
								if vim.bo.filetype ~= "ministarter" then
									vim.cmd [[
										tabnew
										tabmove 0
									]]
								end
								-- we update the PROJECT environment variable
								local obj = vim.system(
									{"zsh", "-c", "source .envrc && printf $PROJECT"},
									{text=true}
								):wait()

								if obj.code == 0 then
									vim.env.PROJECT = obj.stdout
								else
									vim.env.PROJECT = nil
								end
								local bufnr = vim.api.nvim_get_current_buf()
								MiniStarter.open(bufnr)
								vim.notify("Session loaded!")
							end'';
						};
					};
					luaConfig.post = ''
						vim.opt.sessionoptions:remove("terminal")
						vim.opt.sessionoptions:remove("buffers")
						vim.opt.sessionoptions:append("help")
						vim.opt.sessionoptions:append("tabpages")
					'';
				};
				surround = {};
				clue = {
					triggers = [
						{ mode = "n"; keys = "<Leader>"; } # leader
						
						# { mode = "i"; keys = "<C-x>"; } # Omnicomp
						
						{ mode = "n"; keys = "<C-w>"; } # window

						{ mode = "n"; keys = "g"; } # `g` mappings
						{ mode = "x"; keys = "g"; }
						
						{ mode = "n"; keys = "g"; } # `m` mappings
						{ mode = "x"; keys = "g"; }

						{ mode = "n"; keys = "z";} # `z` mappigns
						{ mode = "x"; keys = "z";}

						{ mode = "n"; keys = "]";} # `]` mappigns
						{ mode = "x"; keys = "]";} # hunks
						{ mode = "n"; keys = "[";} # `[` mappigns
						{ mode = "x"; keys = "[";} # hunks

					];
					clues.__raw = ''{
						-- require('mini.clue').gen_clues.builtin_completion(),
						require('mini.clue').gen_clues.windows({
							submode_move = true,
							submode_navigate = true,
							submode_resize = true,
						}),
						require('mini.clue').gen_clues.z(),
						require('mini.clue').gen_clues.g(),
						{ mode = 'n', keys = '<Leader>f', desc = '+Telescope/Find' },
						{ mode = 'n', keys = '<Leader>g', desc = '+Git' },
						{ mode = 'n', keys = '<Leader>h', desc = '+Hunks' },
						{ mode = 'n', keys = '<Leader>o', desc = '+Oil' },
						{ mode = 'n', keys = '<Leader>l', desc = '+LSP' },
						{ mode = 'n', keys = '<Leader>t', desc = '+Tabs' },
						
						{ mode = 'n', keys = 'gp', desc = '+GotoPreview' },
						
						-- Window/Buffer submodes
						{ mode = 'n', keys = ']b', postkeys = ']' },
						{ mode = 'n', keys = ']w', postkeys = ']' },

						{ mode = 'n', keys = '[b', postkeys = '[' },
						{ mode = 'n', keys = '[w', postkeys = '[' },
					}'';
				};
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
				icons = {};
			};
		};
		highlightOverride = {
			MiniCursorword = { bold = true; };
			MiniCursorwordCurrent = { bold = true; };
			MiniOperatorsExchangeFrom = { bg = "#d79921"; bold=true; };
		};
		keymaps = [
			# session mappings
			{
				key = "<leader>S";
				action.__raw = ''
					function()
						-- write local session
						MiniSessions.write("Session.vim")
						vim.notify("Local session written")
					end
				'';
				options.desc = "Session: write local";
			}
			{
				key = "<leader>ss";
				action.__raw = ''
					function()
						-- list and select session
						MiniSessions.select()
						end
				'';
				options.desc = "Session: list";
			}
		];
	};
}
