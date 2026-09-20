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
			config.common.default = "gtk";
			extraPortals = with pkgs; [
				xdg-desktop-portal-gtk
				xdg-desktop-portal-gnome
			];
		};
		mime = { enable = true; };
		mimeApps = {
			enable = true;
			defaultApplications = {
				"inode/directory" = [ "thunar.desktop" ];
				"x-scheme-handler/http" = [ "firefox.desktop" ];
				"x-scheme-handler/https" = [ "firefox.desktop" ];
				"application/pdf" = [ "firefox.desktop" ];
				"text/html" = [ "firefox.desktop" ];
				"text/plain" = [ "neovide.desktop" ];
				"text/x-c++src" = [ "neovide.desktop" ];
				"text/x-qml" = [ "neovide.desktop" ];
				"text/x-lua" = [ "neovide.desktop" ];
				"image/gif" = [ "gimp.desktop" ];
			};
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
		configFile."script/vifmtmux.sh".source = ./script/vifmtmux.sh;
		terminal-exec = {
			enable = true;
			settings = {
				default = [ "kitty.desktop" ];
			};
		};
	};
	programs = {
		home-manager.enable = true;
	};
}
