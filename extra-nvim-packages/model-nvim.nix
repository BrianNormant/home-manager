{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in  vimUtils.buildVimPlugin {
		name = "model-nvim";
		src = fetchFromGitHub {
			owner = "gsuuon";
			repo = "model.nvim";
			rev = "c4653e9";
			hash = "sha256-gz97C8/tlU4SDKLaQ5Lv2NbQP8zQRsNxiIQWHoHHDJY=";
		};
	}
