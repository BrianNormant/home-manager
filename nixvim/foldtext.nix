{config, pkgs, ...}: {
	programs.nixvim = {
		extraPlugins = [ ( pkgs.vimUtils.buildVimPlugin rec {
			pname = "foldtest.nvim";
			version = "v0.1.0";
			src = pkgs.fetchFromGitHub {
				owner = "OXY2DEV";
				repo = "foldtest.nvim";
				tag = version;
				hash = pkgs.lib.fakeHash;
			};
		} ) ];
		extraConfigLua = builtins.readFile ./foldtest.lua;
	};
}
