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
		keymaps = [{
			key = "L";
			action = "<Cmd>Navbuddy<cr>";
			options.desc = "Navbuddy";
		}];
	};
}
