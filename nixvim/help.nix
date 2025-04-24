{...}:
let
in {
	programs.nixvim = {
		plugins = {
			helpview = {
				enable = true;
				lazyLoad = {
					enable = true;
					settings = {
						ft = [ "help" ];
					};
				};
			};
		};
	};
}
