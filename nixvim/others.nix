{ pkgs, ...}:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
in {
	programs.nixvim = {
		extraPlugins = [
			{
				plugin = buildVimPlugin rec {
					pname = "golf.vim";
					version = "abf1bc0";
					src = fetchFromGitHub {
					  owner = "vuciv";
					  repo = "golf";
					  rev = version;
					  hash = "sha256-lCzt+7/uZ/vvWnvWPIqjtS3G3w3qOhI7vHdSQ9bvMKU=";
					};
				};
				optional = true;
			}
		];
		extraConfigLua = ''
			require('lz.n').load {
				"golf.vim",
				cmd = "Golf",
				after = function () end
			}
		'';
	};
}
