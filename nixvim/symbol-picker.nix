{pkgs, ...}:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
in {
	programs.nixvim = {
		extraPlugins = [(buildVimPlugin rec {
			pname = "icon-picker-nvim";
			version = "3ee9a0e";
			src = fetchFromGitHub {
				owner = "ziontee113";
				repo = "icon-picker.nvim";
				rev = version;
				sha256 = "VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
			};
		})];
		extraConfigLua = ''
		require("icon-picker").setup({ disable_legacy_commands = true })
		'';
		keymaps = let selected = "alt_font emoji html_colors nerd_font_v3 symbols"; in
			[
			{
				key = "<C-E>";
				action = "<Cmd>IconPickerNormal ${selected}<cr>";
				options.desc = "Pick Icon";
			}
			{
				key = "<C-I>";
				action = "<Cmd>IconPickerInsert ${selected}<cr>";
				mode = ["i"];
				options.desc = "Pick Icon";
			}
		];
	};
}
