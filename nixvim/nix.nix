{...}: {
	programs.nixvim = {
		plugins = {
			hmts = {
				enable = true;
				lazyLoad.settings = {
					ft = ["nix"];
				};
			};
		};
	};
}
