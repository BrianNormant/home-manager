{pkgs, ... }:
{
	programs.nixvim = {
		plugins = {
			boole = {
				enable = true;
				lazyLoad.settings = {
					keys = [
						{ __unkeyed-1 = "<C-a>"; }
						{ __unkeyed-1 = "<C-x>"; }
					];
					cmd = "Boole";
				};
				settings = {
					mappings = {
						increment = "<C-a>";
						decrement = "<C-x>";
					};
				};
			};
			attempt = {
				enable = true;
				lazyLoad.settings = {
					cmd = [
						"Attempt"
						"AttemptRun"
					];
				};
				luaConfig.post = ''
					vim.api.nvim_create_user_command("Attempt", function()
						require("attempt").new_select()
					end, { desc = "Attempt" })
					vim.api.nvim_create_user_command("AttemptRun", function()
						require("attempt").run()
					end, { desc = "AttemptRun" })
					'';
			};
			nvim-autopairs = {
				enable = true;
				lazyLoad.settings = { event = "DeferredUIEnter"; };
				settings = {
					map_c-w = true;
					map_cr = false;
					map_bs = false;
				};
				luaConfig.post = ''
					local Rule = require('nvim-autopairs.rule')
					local npairs = require('nvim-autopairs')
					--- Autoclose let in
					npairs.add_rules {
						Rule("let", "in ", "nix"):end_wise(function(opts)
							return string.match(opts.line, '^%s*let') ~= nil
						end),
						Rule(" =", ";", "nix"),
						Rule("function%s?[%a_]*%([^%)]*%)$", "end", {"lua"}):use_regex(true),
						Rule("then", "end", "lua"),
						Rule("(", ")", {"lua", "nix"}),
					}
					'';
			};
			undotree = {
				enable = true;
				settings = {
					WindowLayout = 3;
				};
			};
			treesj = {
				enable = true;
				lazyLoad.settings = {
					cmd = [ "TSJToggle" "TSJSplit" "TSJJoin" ];
					keys = [
						{
							__unkeyed-1 = "<c-j>";
							__unkeyed-2 = "<cmd>TSJToggle<cr>";
							desc = "Toggle TSJ";
						}
						{
							__unkeyed-1 = "<leader>j";
							__unkeyed-2 = "<cmd>TSJSplit<cr>";
							desc = "Split TSJ";
						}
						{
							__unkeyed-1 = "<leader>J";
							__unkeyed-2 = "<cmd>TSJJoin<cr>";
							desc = "Join TSJ";
						}
					];
				};
				settings = {
					use_default_keymaps = false;
				};
			};
			wakatime = {
				enable = true;
			};
		};
		keymaps = [
			{
				key = "<a-u>";
				action = "<CMD>UndotreeToggle<CR>";
				options.desc = "Toggle undotree";
			}
		];
	};
}
