{ config, pkgs, lib, ...}: {
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
			config.common = {
				default = [ "gtk" ];
				"org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
				"org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
				"org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
				"org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
			};
			extraPortals = with pkgs; [
				xdg-desktop-portal-gtk
				xdg-desktop-portal-gnome
			];
		};
		# mime = { enable = true; };
		mimeApps = {
			enable = true;
			defaultApplicationPackages = with pkgs; [
				neovide
				firefox
				thunar
				gimp
				vlc
				calibre
			];
			defaultApplications = {
				# Webpage and URI
				"text/html" = [ "firefox.desktop" ];
				"x-scheme-handler/http" = [ "firefox.desktop" ];
				"x-scheme-handler/https" = [ "firefox.desktop" ];
				"x-scheme-handler/about" = [ "firefox.desktop" ];

				# Images
				"image/*" = [ "gimp.desktop" "firefox.desktop" ];

				# Videos
				"video/*" = [ "vlc.desktop" ];
				
				# Audio
				"audio/*" = [ "vlc.desktop" ];

				# Text, Markdown and code
				"text/*" = [ "neovide.desktop" ];

				# PDF
				"application/pdf" = [ "firefox.desktop" ];
				
				# Ebooks
				"application/epub" = [ "calibre-ebook-viewer.desktop" ];
				"application/mobi" = [ "calibre-ebook-viewer.desktop" ];

				# Documents (word, livreoffice docs)
				"application/vnd.oasis.opendocument.text" = [ "libreoffice-writer.desktop" ];
				"application/vnd.oasis.opendocument.spreadsheet" = [ "libreoffice-calc.desktop" ];
				"application/vnd.oasis.opendocument.presentation" = [ "libreoffice-impress.desktop" ];
				"application/msword" = [ "libreoffice-writer.desktop" ];
				"application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "libreoffice-writer.desktop" ];
				"application/vnd.ms-excel" = [ "libreoffice-calc.desktop" ];
				"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "libreoffice-calc.desktop" ];
				"application/vnd.ms-powerpoint" = [ "libreoffice-impress.desktop" ];
				"application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "libreoffice-impress.desktop" ];

				# File browser
				"inode/directory" = [ "thunar.desktop" ];
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
	home.activation.updateMimeInfoCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
	  ${pkgs.python3}/bin/python3 ${pkgs.writeText "update-mimeinfo-cache.py" ''
import os, configparser

mimeapps = os.path.expanduser("~/.config/mimeapps.list")
cache = os.path.expanduser("~/.local/share/applications/mimeinfo.cache")

# Read defaults from mimeapps.list
defaults = {}
if os.path.exists(mimeapps):
    config = configparser.ConfigParser()
    config.optionxform = str          # preserve case
    config.read(mimeapps)
    if "Default Applications" in config:
        defaults = dict(config["Default Applications"])

if not defaults:
    exit(0)

# Ensure the cache file exists
os.makedirs(os.path.dirname(cache), exist_ok=True)
if not os.path.exists(cache):
    with open(cache, "w") as f:
        f.write("[MIME Cache]\n")

with open(cache, "r") as f:
    lines = f.readlines()

out = []
in_mime_cache = False
handled = set()

for line in lines:
    stripped = line.strip()
    if stripped.startswith("[") and stripped.endswith("]"):
        if stripped == "[MIME Cache]":
            in_mime_cache = True
        else:
            in_mime_cache = False
        out.append(line)
        continue

    if in_mime_cache and "=" in line:
        key, val = line.split("=", 1)
        key = key.strip()
        if key in defaults:
            # Replace the whole entry with just the default app.
            # To prepend instead, see note below.
            new_val = defaults[key] + ";"
            out.append(f"{key}={new_val}\n")
            handled.add(key)
        else:
            out.append(line)
    else:
        out.append(line)

if not in_mime_cache:
    out.append("[MIME Cache]\n")

for key, val in defaults.items():
    if key not in handled:
        out.append(f"{key}={val};\n")

with open(cache, "w") as f:
    f.writelines(out)
	  ''}
	'';
}
