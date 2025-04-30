{...}: {
	home = {
		username = "brian";
		homeDirectory = "/home/brian";
		stateVersion = "24.05";
	};
	xdg = {
		mime = {
			enable = true;
		};
		mimeApps = {
			defaultApplications = {
				"text/plain" = ["neovide.desktop"];
				"inode/directory" = ["Thunar.desktop"];
			};
		};
	};
	programs = {
		home-manager.enable = true;
	};
}
