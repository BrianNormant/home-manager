{pkgs, ...}:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
in {
	programs.nixvim = {
		extraPlugins = [
			{
				plugin = buildVimPlugin rec {
					pname = "icon-picker.nvim";
					version = "3ee9a0e";
					src = fetchFromGitHub {
						owner = "ziontee113";
						repo = "icon-picker.nvim";
						rev = version;
						sha256 = "VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
					};
				};
				optional = true;
			}
		];
		extraConfigLua = let
		    selected = "alt_font emoji html_colors nerd_font_v3 symbols";
		in ''
			require('lz.n').load { {
				"icon-picker.nvim",
				keys = {
					{
						"<C-q>",
						"<CMD>IconPickerNormal ${selected}<CR>",
					},
					{
						"<C-q>",
						"<CMD>IconPickerInsert ${selected}<CR>",
						mode = "i",
					}
			  	},
				after = function()
					require("icon-picker").setup { disable_legacy_commands = true }
				end
			} }
		'';
	};
}
