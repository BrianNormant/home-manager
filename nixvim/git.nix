{config, pkgs, ...}: {
	programs.nixvim = {
		extraPackages = with pkgs; [
			git-extras
		];
		plugins = {
			fugitive.enable = true;
			# diffview = {
			# 	enable = true;
			# 	lazyLoad.settings = {
			# 		cmd = [ "DiffviewOpen" ];
			# 	};
			# };
			gitsigns = {
				enable = true;
				lazyLoad.settings = {
					event = [ "DeferredUIEnter" ];
				};
				luaConfig.content = builtins.readFile ./gitsigns.lua;
			};
		};
		# Workaround as Fugitive* are vimscript events
		extraConfigLuaPost = ''
		_G.fugitive_help = function()
			${builtins.readFile ./fugitive-help-fn.lua}
		end
		'';
		keymaps = [
			{
				key = "<leader>G";
				action = "<CMD>Git<CR>";
				options.desc = "Fugitive";
			}
			{
				key = "<leader>gl";
				action = "<CMD>Git log --graph --all --oneline --abbrev-commit --decorate<CR>";
				options.desc = "Fugitive Git pretty log";
			}
			{
				key = "<leader>gd";
				action = "<CMD>Gclog<CR>";
				options.desc = "Fugitive Git log to qlf";
			}
			{
				key = "<leader>gd";
				action = ":'<,'>Gclog<CR>";
				options.desc = "Fugitive Git grep to qfl";
				mode = ["v"];
			}
			{
				key = "<leader>gf";
				action = "<CMD>Ggrep -q ";
				options.desc = "Fugitive Git grep to qfl";
			}
			{
				key = "<leader>gc";
				action = "<CMD>Git commit<cr>";
				options.desc = "Fugitive Commit";
			}
			{
				key = "<leader>gp";
				action = "<CMD>Git pull<cr>";
				options.desc = "Fugitive Pull";
			}
			{
				key = "<leader>gP";
				action = "<CMD>Git push<cr>";
				options.desc = "Fugitive Push";
			}
			{
				key = "<leader>gri";
				action = "<CMD>Git rebase --continue";
				options.desc = "Fugitive Rebase Continue";
			}
			{
				key = "<leader>gR";
				action = "<CMD>Git rebase --abort";
				options.desc = "Fugitive Rebase Abort";
			}
			{
				key = "<leader>gm";
				action = "<CMD>Git mergetool<cr>";
				options.desc = "Fugitive Mergetool resolve conflicts";
			}
		];
	};
}
