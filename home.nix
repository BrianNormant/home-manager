{config, pkgs, hostname, ... }: let
mkMutableSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
	imports = [
		./zsh.nix
		./nixvim.nix
		./vifm.nix
		./vr.nix
		./git.nix
		./ssh.nix
		./menus.nix
		./brian-services.nix
		./kitty.nix
		./tmux.nix
		./niri.nix
		./homeconfig.nix
		./shellutils.nix
		./unison.nix
		./sound.nix
		./status-bar.nix
	];
	home.packages = with pkgs; [
		xrizer
		nix-output-monitor
		manix
		cool-retro-term
		usbutils
		hyprpicker

		networkmanagerapplet
		poweralertd
		libnotify
		libreoffice
		radeontop
		nspire-tools
		wl-clipboard
		xsel

		xournalpp # pdf editor
		calibre # ebook reader
		gimp # image editor
		shotcut # video editor
		# qt-web-engine is outdated
		rimsort
		youtube-music
		rmapi
		tridactyl-native

		zafiro-icons
		(callPackage ./pkgs/wl-shimeji.nix {inherit pkgs;})
	];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
		".config/waypaper/config.ini".source = ./config/waypaper/config.ini;
		".config/tridactyl/tridactylrc".source = ./config/tridactylrc;
		".mozilla/native-messaging-hosts/tridactyl.json".text = ''
			{
				"name": "tridactyl",
				"description": "Tridactyl native command handler",
				"path": "${pkgs.tridactyl-native}/bin/native_main",
				"type": "stdio",
				"allowed_extensions": [ "tridactyl.vim@cmcaine.co.uk","tridactyl.vim.betas@cmcaine.co.uk", "tridactyl.vim.betas.nonewtab@cmcaine.co.uk" ]
			}
		'';

		".config/script/media.zsh".text = builtins.readFile ./script/fetch-and-format-media.zsh;
		".config/script/media.zsh".executable = true;
		".config/script/replay.sh" = {
			source = ./script/replay-notify.sh;
			executable = true;
		};
		".config/script/record-replay.sh" = {
			source = ./script/record-replay.sh;
			executable = true;
		};
		".config/script/switch-playerctl.zsh".source = ./script/switch-controlled-player.sh;
		".config/script/set-workspace-name.sh" = {
			source = ./script/set-workspace-name.sh;
			executable = true;
		};

		".rmapi".source = mkMutableSymlink "${config.home.homeDirectory}/.config/rmapi/rmapi.conf";

		# idris
		".pack/user/pack.toml".source = ./config/idris/pack.toml;

		# wallpaper
		".config/script/random-swww.sh" = {
			source = ./script/random-swww.sh;
			executable = true;
		};
		".config/script/random-waypaper.sh" = {
			source = ./script/random-waypaper.sh;
			executable = true;
		};
		".config/wlxoverlay/wayvr.conf.d/dashboard.yaml".source = ./config/wlxoverlay/wayvr.conf.d/dashboard.yaml;

		# Thunar "Open terminal here" action
		".config/xfce4/helpers.rc".text = ''
			TerminalEmulator=kitty
		'';

		".config/winapps/winapps.conf".source = ./config/winapps/winapps.conf;
	};

	gtk = {
		enable = true;
		theme = {
			name = "Gruvbox-Dark";
			package = pkgs.gruvbox-gtk-theme;
		};
		iconTheme = {
			name = "Gruvbox-Plus-Dark";
			package = pkgs.gruvbox-plus-icons.override {
				folder-color = "pumpkin";
			};
		};
	};
	dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

	home.pointerCursor = {
		name = "phinger-cursors-dark";
		package = pkgs.phinger-cursors;
		size = 32;
		gtk.enable = true;
	};

	programs = {
		nushell = {
			enable = true;
			configFile.source = ./config/nushell/default-config.nu;
			extraConfig = with pkgs.nushellPlugins; ''
				plugin add ${polars}/bin/nu_plugin_polars
				'';
		};
		man = {
			enable = true;
			generateCaches = true;
		};
		firefox.enable = true;
		zapzap = {
			enable = true;
			settings = {
				system = {
					scale = 150;
					theme = "dark";
					wayland = true;
				};
			};
		};
	};
}
