{pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			nvim-bqf = {
				enable = true;
				settings = {
					preview = {
						auto_preview = false;
						border = "double";
						show_scroll_bar = false;
						winblend = 20;
					};
				};
			};
		};
		keymaps = [
			{
				key = "<leader>q";
				action.__raw = ''
					function()
						require('quicker').toggle()
					end
				'';
				options.desc = "Toggle quickfix";
			}
		];
		extraConfigLuaPost = ''
			_G.quickfix_help = function()
				${builtins.readFile ./quickfix-help-fn.lua}
			end
		'';
	};
}
