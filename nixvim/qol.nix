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
			spider = {
				enable = true;
				settings = {
					subwordMovement = true;
					skipInsignificantPunctuation = true;
				};
				luaConfig.post = ''
					vim.keymap.set({"n", "o", "x"}, "w", "<cmd>lua require('spider').motion('w')<CR>")
					vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>")
					vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>")
				'';
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
			};
			various-textobjs = {
				enable = true;
				settings = {
					keymaps = {
						useDefaults = true;
						disabledDefaults = [
							"R"
							"r"
							"iq" "aq"
						];
					};
				};
				luaConfig.post = ''
					vim.keymap.set({"o", "x"}, "iw", "<cmd>lua require('various-textobjs').subword('inner')<CR>")
				'';
				lazyLoad.settings = {
					event = "DeferredUIEnter";
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
