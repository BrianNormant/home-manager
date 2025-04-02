{pkgs, ...}: {
	programs.nixvim = {
		plugins.none-ls = {
			enable = true;
			lazyLoad.settings = {
				ft = [ "c" "elixir" "nix" "php" "java" ];
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
				diagnostics.pmd = {
					enable = true;
					settings.extra_args = [
						"--rulesets"
						"category/java/bestpractices.xml,category/jsp/bestpractices.xml"
					];
				};
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
	home.file.".java/checkstyle/checkstyle.xml".source = ./config/checkstyle.xml;
}
