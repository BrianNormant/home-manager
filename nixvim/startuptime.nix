{config, pkgs, ...}: {
	programs.nixvim = {
		extraPlugins = [ ( pkgs.vimUtils.buildVimPlugin rec {
			pname = "nvim-startup";
			version = "v0.6.0";
			src = pkgs.fetchgit {
				url = "https://git.sr.ht/~henriquehbr/nvim-startup.lua";
				tag = version;
				hash = "sha256-96XvHPUzFN7ehUXTV+0+dBPdVej+57icuECRVYMqZaA";
			};
		} ) ];
		extraConfigLuaPost = ''
			require('nvim-startup').setup {}
		'';
	};
}
