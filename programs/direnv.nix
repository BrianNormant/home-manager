{...}: {
	programs.direnv = {
		enable = true;
		enableZshIntegration = true;
		enableBashIntegration = false;
		silent = true;
		config = {
			whitelist = {
				prefix = [
					"/home/brian/Prog"
					"/home/brian/Documents/Udes"
					"/home/brian/nixos-config"
				];
			};
		};
	};
}
