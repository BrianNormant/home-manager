{pkgs, ...}: {
	programs.nixvim = {
		plugins.none-ls = {
			enable = true;
			lazyLoad.settings = {
				event = [ "DeferredUIEnter" ];
			};
			sources = {
				# C/C++
				diagnostics.cppcheck.enable = true;
				diagnostics.credo.enable = true;
			};
		};
	};
	home.file.".java/checkstyle/checkstyle.xml".source = ../config/checkstyle.xml;
}
