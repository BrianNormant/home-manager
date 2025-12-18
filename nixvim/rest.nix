{pkgs, config, ... }: {
	programs.nixvim = {
		plugins = {
			rest = {
				enable = true;
				lazyLoad.settings = { ft = "http"; };
			};
		};
	};
}
