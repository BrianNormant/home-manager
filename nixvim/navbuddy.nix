{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			navbuddy = {
				enable = true;
				lsp.autoAttach = true;
				window = {
					border = "double";
				};
				mappings = {
					"<Up>"    = "previous_sibling";
					"<Down>"  = "next_sibling";
					"<Right>" = "children";
					"<Left>"  = "parent";
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
