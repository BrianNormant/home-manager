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
			config.common.default = "*";
			extraPortals = with pkgs; [
				xdg-desktop-portal-gtk
				xdg-desktop-portal-gnome
			];
		};
		mime = {
			enable = true;
		};
		desktopEntries = {
			vifmtmux = {
				name = "vifm";
				genericName = "file manager";
				exec = "zsh \"~/.config/script/vifmtmux.sh\" %u";
				terminal = false;
				categories = [ "Utility" ];
				mimeType = [ "inode/directory" ];
			};
		};
		configFile."mimeapps.list".source = ./config/mimeapps.list;
		configFile."script/vifmtmux.sh".source = ./script/vifmtmux.sh;
	};
	programs = {
		home-manager.enable = true;
	};
}
