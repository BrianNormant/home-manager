{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			rainbow-delimiters.enable = true;
			indent-blankline.enable = true;
			indent-blankline.settings = {
				indent = {
					highlight = [
						"Comment"
						"MarkdownH1"
						"MarkdownH2"
						"MarkdownH3"
						"MarkdownH4"
						"MarkdownH5"
						"MarkdownH6"
					];
					char = "▏";
					tab_char = "·";
				};
				scope = {
					enabled = true;
					highlight = "Blue";
					char = "║";
					show_end = false;
				};
			};
		};
	};
}
