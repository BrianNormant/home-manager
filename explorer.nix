{...}: {
	programs = {
		vifm = {
			enable = true;
			extraConfig = builtins.readFile ./config/vifm/vifmrc;
		};
	};
	home.file = {
		".config/vifm/colors".source = ./config/vifm/colors;
		".config/vifm/devicons".source = ./config/vifm/devicons;
	};
}
