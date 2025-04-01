{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			navbuddy.enable = true;
			navbuddy = {
				lsp.autoAttach = true;
				window = {
					border = "double";
				};
			};
		};
	};
}
