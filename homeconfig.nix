{ config, ...}: {
	home = {
		username = "brian";
		homeDirectory = "/home/brian";
		stateVersion = "24.05";
		# Copy the .desktop entries from nix-profile because walker doesn't find them on it's own
		activation = {
			copyDesktopApp = {
				after = [ "writeBoundary" "createXdgUserDirectories" ];
				before = [];
				data = ''
					cp -f /home/brian/.nix-profile/share/applications/*.desktop \
						/home/brian/.local/share/applications
				'';
			};
		};
	};
	xdg = {
		enable = true;
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
