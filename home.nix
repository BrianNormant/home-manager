{config, pkgs, hostname, ... }: let
	mkMutableSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
	home.packages =
		(import ./installed-pkgs/cli-utils.nix     pkgs) ++
		(import ./installed-pkgs/nix-utils.nix     pkgs) ++
		(import ./installed-pkgs/desktop-utils.nix pkgs) ++
		(import ./installed-pkgs/office.nix        pkgs) ++
		(import ./installed-pkgs/desktop-apps.nix  pkgs) ++
		(import ./installed-pkgs/dev-utils.nix     pkgs) ++
		(if hostname == "BrianNixDesktop"
			then (import ./installed-pkgs/games.nix pkgs)
		else []) ++
		(if hostname == "BrianNixLaptop"
			then (import ./installed-pkgs/piano.nix pkgs)
		else [])
		;

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {

		".config/script/media.zsh".text = builtins.readFile ./script/fetch-and-format-media.zsh;
		".config/script/media.zsh".executable = true;
		".config/script/switch-playerctl.zsh".source = ./script/switch-controlled-player.sh;

		".rmapi".source = mkMutableSymlink "${config.home.homeDirectory}/.config/rmapi/rmapi.conf";

		# idris
		".pack/user/pack.toml".source = ./config/idris/pack.toml;

		# Winapps
		".config/winapps/winapps.conf".source = ./config/winapps/winapps.conf;

		# Helix
		".config/helix/config.toml".source = ./config/helix/config.toml;
	};

	# ----------------------------------[ Theming ]-----------------------------------
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
}
