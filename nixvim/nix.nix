{...}: {
	programs.nixvim = {
		plugins = {
			none-ls.sources = {
				diagnostic.statix.enable = true;
				code_actions.statix.enable = true;
			};
		};
	};
}
