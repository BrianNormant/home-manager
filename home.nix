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
		./hyprland.nix
		./homeconfig.nix
		./shellutils.nix
		./unison.nix
		./sound.nix
	];
	home.packages = with pkgs; [
		nix-output-monitor
		manix
		cool-retro-term
		usbutils

		networkmanagerapplet
		(callPackage ./pep8.nix {})
		libnotify
		libreoffice
		radeontop
		nspire-tools
		wl-clipboard
		xsel

		xournalpp # pdf editor
		calibre # ebook reader

		zafiro-icons
	];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
		".config/waypaper/config.ini".source = ./config/waypaper/config.ini;
		".config/.tridactylrc".source = ./config/tridactylrc;

		".config/hypr/brightness.nu".source = ./script/brightness.nu;
		".config/hypr/plugged.nu".source = ./script/plugged.nu;
		".config/hypr/volume.nu".source = ./script/volume.nu;
			
		".config/script/media.zsh".text = builtins.readFile ./script/fetch-and-format-media.zsh;
		".config/script/media.zsh".executable = true;

		".config/script/switch-playerctl.zsh".source = ./script/switch-controlled-player.sh;

		".rmapi".source = mkMutableSymlink "${config.home.homeDirectory}/.config/rmapi/rmapi.conf";

		# idris
		".pack/user/pack.toml".source = ./config/idris/pack.toml;
	};

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
		firefox.enable = true;
	};
}
