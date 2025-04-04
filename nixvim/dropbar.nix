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
				sp = "#665c54";
				bg = "#313131";
				underline = true;
			};
			WinBarNC = {
				sp = "#665c54";
				bg = "#313131";
				underline = true;
			};
		};
	};
}
