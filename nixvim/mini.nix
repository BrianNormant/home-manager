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
				sessions = {
					autowrite = true;
					autoread = true;
					hooks = {
						post = {
							read.__raw = ''function()
								vim.cmd [[
									tabnew
									tabmove 0
								]]
								local bufnr = vim.api.nvim_get_current_buf()
								MiniStarter.open(bufnr)
							end'';
						};
					};
				};
				clue = {
					triggers = [
						{ mode = "n"; keys = "<Leader>"; } # leader
						
						{ mode = "i"; keys = "<C-x>"; } # Omnicomp
						
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
						require('mini.clue').gen_clues.builtin_completion(),
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
			};
		};
		highlightOverride = {
			MiniCursorword = { bold = true; };
			MiniCursorwordCurrent = { bold = true; };
			MiniOperatorsExchangeFrom = { bg = "#d79921"; bold=true; };
		};
	};
}
