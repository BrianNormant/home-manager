{pkgs, ...}:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
in {
	programs.nixvim = {
		plugins = {
			icon-picker = {
				enable = true;
				lazyLoad.settings = {
					keys = let
						selected = "alt_font emoji html_colors nerd_font_v3 symbols";
					in [
						{ __unkeyed-1 = "<C-q>"; __unkeyed-2 = "<CMD>IconPickerNormal ${selected}<CR>"; mode = "n"; }
						{ __unkeyed-1 = "<C-q>"; __unkeyed-2 = "<CMD>IconPickerInsert ${selected}<CR>"; mode = "i"; }
					];
				};
				settings = {
					disable_legacy_commands = true;
				};
			};
		};
	};
}
