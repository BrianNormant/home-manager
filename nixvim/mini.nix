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
			};
		};
		highlightOverride = {
			MiniCursorword = { bold = true; };
			MiniCursorwordCurrent = { bold = true; };
			MiniOperatorsExchangeFrom = { bg = "#d79921"; bold=true; };
		};
	};
}
