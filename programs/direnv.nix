{...}: {
	programs.direnv = {
		enable = true;
		enableZshIntegration = true;
		enableBashIntegration = false;
		silent = true;
	};
}
