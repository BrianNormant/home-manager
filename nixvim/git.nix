{config, pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			fugitive.enable = true;
			diffview.enable = true;
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

		vim.cmd "autocmd User FugitiveIndex,FugitiveObject nmap <buffer> g? :lua _G.fugitive_help()<CR>"
		'';
		keymaps = [
			{
				key = "<leader>G";
				action = "<CMD>Git<CR>";
				options.desc = "Fugitive";
			}
			{
				key = "<leader>gd";
				action = "<CMD>Gclog<CR>";
				options.desc = "Fugitive send file log to qfl";
			}
			{
				key = "<leader>gd";
				action = ":'<,'>Gclog<CR>";
				options.desc = "Fugitive Grep to qfl";
				mode = ["v"];
			}
			{
				key = "<leader>gf";
				action = "<CMD>Ggrep -q ";
				options.desc = "Fugitive Grep to qfl";
			}
		];
	};
}
