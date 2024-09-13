{ config, pkgs, hostname, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
	nix-output-monitor
	manix
	usbutils
	nushell
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
		".config/nvim-simple/init.lua".text = builtins.readFile ./nvim-simple.lua;
	
		".config/hypr/wallpaper.nu".text = builtins.readFile ./wallpaper.nu;
		".config/hypr/wallpaper.nu".executable = true;
		
		".config/hypr/brightness.nu".text = builtins.readFile ./brightness.nu;
		".config/hypr/plugged.nu".text = builtins.readFile ./plugged.nu;
		".config/hypr/volume.nu".text = builtins.readFile ./volume.nu;
			
		".config/script/media.zsh".text = builtins.readFile ./fetch-and-format-media.zsh;
		".config/script/media.zsh".executable = true;

		".config/script/switch-playerctl.zsh".text = builtins.readFile ./switch-controlled-player.sh;
		".config/script/switch-playerctl.zsh".executable = true;
		".config/script/replay.sh".text = builtins.readFile ./replay.sh;
		".config/script/replay.sh".executable = true;

		".config/hypr/hyprlock.conf".text = (import ./hyprlock.nix) (if hostname == "BrianNixDesktop" then "DP-1" else "eDP-1");
		".config/hypr/hypridle.conf".text = builtins.readFile ./hypridle.conf;
  };

	home.pointerCursor = {
		name = "phinger-cursors-dark";
		package = pkgs.phinger-cursors;
		size = 32;
		gtk.enable = true;
	};


	systemd.user = (import ./brian-services.nix) pkgs;

	xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-gtk ];

	gtk = {
		enable = true;
		theme = {
			name = "gruvbox-dark";
			package = pkgs.gruvbox-dark-gtk;
		};
	};

	programs.git = {
		enable = true;
		userName = "BrianNixDesktop";
		userEmail = "briannormant@gmail.com";
	};

	programs.rofi = {
		enable = true;
		package = pkgs.rofi-wayland;
		plugins = let
			build-against-rofi-wayland = plugin: plugin.overrideAttrs ( final: self: {
				version = "wayland";
				buildInputs = with pkgs; [
					rofi-wayland-unwrapped # here we replace rofi by rofi-wayland
					libqalculate
					glib
					cairo
				];
			});

			rofi-wayland-plugins = with pkgs; [
				rofi-calc
				rofi-emoji
			];
		in builtins.map build-against-rofi-wayland rofi-wayland-plugins;
	};

	services.wob.enable = true; # TODO connect wob to script

	programs.firefox.enable = true;

	programs.waybar = (import ./waybar.nix) hostname;
	wayland.windowManager.hyprland = (import ./hyprland.nix) hostname;

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/et:c/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/brian/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
	FLAKE = "/home/brian/nixos-config";
  };

	services.unison.enable = (hostname == "BrianNixLaptop");
	services.unison.pairs."Music" = {
		roots = [
			"/home/brian/Music"
			"ssh://BrianNixDesktopI//home/brian/Music"
		];
		stateDirectory = "${config.xdg.dataHome}/unison/Music";
	};
	services.unison.pairs."Prog" = {
		roots = [
			"/home/brian/Prog"
			"ssh://BrianNixDesktopI//home/brian/Prog"
		];
		stateDirectory = "${config.xdg.dataHome}/unison/Prog";
	};
	services.unison.pairs."Wallpapers" = {
		roots = [
			"/home/brian/Wallpapers"
			"ssh://BrianNixDesktopI//home/brian/Wallpapers"
		];
		stateDirectory = "${config.xdg.dataHome}/unison/Wallpapers";
	};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

	# let 
	# 	nvim-treesitter-parsers-http = pkgs.vimPlugins.nvim-treesitter-parsers.http.overrideAttrs  (final: self: {
	# 		version = "test";
	# 		src = pkgs.fetchFromGitHub {
	# 			owner = "rest-nvim";
	# 			repo = "tree-sitter-http";
	# 			rev = "261d78f";
	# 			sha256 = "sha256-Kh5CeVc6wtqRHb/RzFALk3pnnzzC/OR3qkDwIQH+XlA=";
	# 		};
	# 	});
	# in programs.neovim = {
	programs.neovim = (import ./nvim.nix) {pkgs=pkgs;};
}
