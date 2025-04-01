{config, pkgs, ...}: {
	programs.nixvim = {
		extraPlugins = [ ( pkgs.vimUtils.buildVimPlugin rec {
			pname = "foldtext-nvim";
			version = "v1.0.0";
			src = pkgs.fetchFromGitHub {
				owner = "OXY2DEV";
				repo = "foldtext.nvim";
				tag = version;
				hash = "sha256-2tdAlxKRFtrnTukAXTLXbIa9J7JZ6BisyxJGYGW4SR8=";
			};
		} ) ];
		extraConfigLua = builtins.readFile ./foldtext.lua;
		globalOpts = {
			foldcolumn     = "0";
			foldlevel      = 99;
			foldlevelstart = 99;
			foldenable     = true;
		};
	};
}
