{pkgs, ... }: {
	programs.nixvim = {
		extraPlugins = [pkgs.vimPlugins.registers-nvim];
		extraConfigLua = builtins.readFile ./registers.lua;
	};
}
