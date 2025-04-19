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
				settings.event = [ "DeferredUIEnter" ];
			};
		};
		highlightOverride = {
			WinBar = {
				link = "Normal";
			};
			WinBarNC = {
				link = "Normal";
			};
		};
	};
}
