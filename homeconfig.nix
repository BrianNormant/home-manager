{ config, pkgs, ...}: {
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
		autostart.enable = true;

		portal = {
			enable = true;
			xdgOpenUsePortal = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-gtk
				xdg-desktop-portal-hyprland
			];
		};
		mime = {
			enable = true;
		};
		configFile."mimeapps.list".source = ./config/mimeapps.list;
	};
	programs = {
		home-manager.enable = true;
	};
}
