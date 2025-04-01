{config, pkgs, ...}: {
	programs.nixvim = {
		plugins.dropbar = {
			enable = true;
			lazyLoad = {
				settings.keys = [
					{
						__unkeyed-1 = "<F2>";
						__unkeyed-2.__raw = "function() require('dropbar.api').pick() end";
						desc = "Dropbar pick";
					}
				];
			};
			luaConfig.pre = ''
				vim.cmd [[
				hi WinBar   guisp=#665c54 gui=underline guibg=#313131
				hi WinBarNC guisp=#665c54 gui=underline guibg=#313131
				]]
			'';
		};
	};
}
