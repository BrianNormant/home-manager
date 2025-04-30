{ pkgs, ... }: {
	programs = {
		lsd = { enable = true; };
		oh-my-posh = {
			enable = false;
			enableZshIntegration = true;
			enableNushellIntegration = true;
			useTheme = "gruvbox";
		};
	};
	home.file = {
		".config/lsd/icons.yaml".source = ./config/lsd.icons.yaml;
	};
}
