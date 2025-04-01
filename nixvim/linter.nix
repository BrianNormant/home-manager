{pkgs, ...}: {
	programs.nixvim = {
		plugins.none-ls = {
			enable = true;
			lazyLoad.settings = {
				ft = [ "c" "elixir" "nix" "php" ];
			};
			sources = {
				# Nix
				code_actions.statix.enable = true;
				diagnostics.statix.enable = true;

				# C/C++
				diagnostics.cppcheck.enable = true;

				diagnostics.credo.enable = true;

				# PHP
				diagnostics.phpcs.enable = true;
				diagnostics.phpmd.enable = true;
				diagnostics.phpstan.enable = true;

				# Java
				diagnostics.pmd.enable = true;
				diagnostics.checkstyle = {
					enable = true;
					settings.extra_args = [
						"-c"
						"/home/brian/.java/checkstyle/checkstyle.xml"
					];
				};
				formatting.google_java_format.enable = true;
			};
		};
	};
}
