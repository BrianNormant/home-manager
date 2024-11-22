{config, pkgs, hostname, blink, ... }: let

mkMutableSymlink = config.lib.file.mkOutOfStoreSymlink;

cmus-tmux = pkgs.tmuxPlugins.mkTmuxPlugin rec {
	pluginName = "tmux-cmus";
	version = "2";
	rtpFilePath = ( builtins.replaceStrings ["_"] ["-"] pluginName ) + ".tmux";
	src = pkgs.fetchFromGitHub {
		owner = "Mpdreamz";
		repo  = "tmux-cmus";
		rev = "df9e6f1";
		hash = "sha256-5VwzlvuhHiVlfSG+wql+enS4MPMU0bYNaZJhEgIeUmo=";
	};
};
in {
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
  home.stateVersion = "24.05"; # Please read the comment before changingDown
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
	nix-output-monitor
	manix
	usbutils
	neovide
	networkmanagerapplet
	(callPackage ./pep8.nix {})
	hyprpicker
	hyprpanel

	lxqt.lxqt-wayland-session
	lxqt.lxqt-session
	lxqt.lxqt-config
	lxqt.lxqt-runner
	lxqt.pcmanfm-qt
	lxqt.lxqt-notificationd
	lxqt.lxqt-themes

	zafiro-icons
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  		".config/nvim/lua/supermaven.lua".source = ./supermaven.lua;
		".config/nvim-simple/init.lua".text = builtins.readFile ./nvim-simple.lua;
		".config/lxqt".source = ./lxqt;
	
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
		".cache/ags/hyprpanel/options.json".source = ./hyprpanel.json;

		# ".java/home/jdk-8".source =  pkgs.jdk8  + "/lib/openjdk";
		".java/home/jdk-17".source = pkgs.jdk17 + "/lib/openjdk";
		".java/home/jdk-21".source = pkgs.jdk   + "/lib/openjdk";
		".java/checkstyle/checkstyle.xml".text = builtins.readFile ./checkstyle.xml;
		".config/neovide".source = mkMutableSymlink "${config.home.homeDirectory}/.config/nvim";
		".rmapi".source = mkMutableSymlink "${config.home.homeDirectory}/.config/rmapi/rmapi.conf";

		".config/openvr/openvrpaths.vrpath.monado".text = ''
{
	"config" :
	[
		"/home/brian/.local/share/Steam/config"
	],
	"external_drivers" : null,
	"jsonid" : "vrpathreg",
	"log" :
	[
		"/home/brian/.local/share/Steam/logs"
	],
	"runtime" :
	[
		"${pkgs.opencomposite}/lib/opencomposite"
	],
	"version" : 1
}
		'';
  };

	home.pointerCursor = {
		name = "phinger-cursors-dark";
		package = pkgs.phinger-cursors;
		size = 32;
		gtk.enable = true;
	};


	systemd.user = (import ./brian-services.nix) pkgs;

	# xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-gtk ];

	# gtk = {
	# 	enable = true;
	# 	theme = {
	# 		name = "gruvbox-dark";
	# 		package = pkgs.gruvbox-dark-gtk;
	# 	};
	# };

	programs.lsd = { enable = true; };
	home.file.".config/lsd/icons.yaml".text = ''
extension:
	gnuplot: 
	data: 
	'';

	programs.nushell = {
		enable = true;
		configFile.source = ./default-config.nu;
		extraConfig = with pkgs.nushellPlugins; ''
			plugin add ${polars}/bin/nu_plugin_polars
		'';
	};

	programs.oh-my-posh = {
		enable = true;
		enableZshIntegration = true;
		enableNushellIntegration = true;
		useTheme = "gruvbox";
	};

	programs.kitty = {
		enable = true;
		font = {
			name = "FiraCode Nerd Font";
			package = pkgs.rictydiminished-with-firacode;
			size = 12;
		};
		settings = {
			enable_audio_bell = false;
			confirm_os_window_close = "0";
			background_opacity = "0.8";
			dynamic_background_opacity = true;
			background_tint = "0.0";
		};
		extraConfig = ''
			map alt+F1 set_background_opacity +0.1
			map alt+F2 set_background_opacity -0.1
		'';
	};


	programs.git = {
		enable = true;
		userName = "BrianNixDesktop";
		userEmail = "briannormant@gmail.com";
	};

	programs.rofi = {
		enable = true;
		package = pkgs.rofi-wayland;
		theme = "gruvbox-dark-soft";
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

	programs.firefox.enable = true;

	programs.waybar = (import ./waybar.nix) hostname;
	
	xdg.portal = {
		extraPortals = with pkgs; [
			lxqt.xdg-desktop-portal-lxqt
			xdg-desktop-portal-hyprland
		];
		xdgOpenUsePortal = true;
	};
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
	services.unison.pairs."Documents" = {
		roots = [
			"/home/brian/Documents"
			"ssh://BrianNixDesktopI//home/brian/Documents"
		];
		stateDirectory = "${config.xdg.dataHome}/unison/Documents";
	};
	services.unison.pairs."Prog" = {
		roots = [
			"/home/brian/Prog"
			"ssh://BrianNixDesktopI//home/brian/Prog"
		];
		stateDirectory = "${config.xdg.dataHome}/unison/Prog";
# UNISON='/home/brian/.local/share/unison/Prog' unison /home/brian/Prog ssh://BrianNixDesktopI//home/brian/Prog -ignore='Name .git' -ignore='Name .ccls-cache' -ignore='Name *log*' -ignore='Name *bin*' -ignore='Name *.jar' -ignore='Name result' -ignore='Name target' -ignore='Name .m2'
		commandOptions = {
			ignore = [
				"Name .git"
				"Name .ccls-cache"
				"Name *log*"
				"Name *bin*"
				"Name *.jar"
				"Name result" # nix build output
				"Name target" # maven build output
				"Name .m2"    # maven repo
			];
		};
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
	home.file.".config/nvim/syntax/nu.vim".text   = builtins.readFile ./custom-syntax-vim/nu-syntax.vim;
	home.file.".config/nvim/ftdetect/nu.vim".text = builtins.readFile ./custom-syntax-vim/nu-ftdetect.vim;
	home.file.".config/nvim/syntax/pep.vim".text   = builtins.readFile ./custom-syntax-vim/pep-syntax.vim;
	home.file.".config/nvim/ftdetect/pep.vim".text = builtins.readFile ./custom-syntax-vim/pep-ftdetect.vim;
	home.file.".config/nvim/ftdetect/http.vim".text = builtins.readFile ./custom-syntax-vim/http-ftdetect.vim;
	home.file.".config/nvim/ftdetect/idr.vim".text = builtins.readFile ./custom-syntax-vim/idr-ftdetect.vim;
	programs.neovim = (import ./nvim.nix) {inherit pkgs; inherit blink;};
	programs.tmux = {
		enable = true;
		clock24 = true;
		escapeTime = 10;
		keyMode = "vi";
		plugins = with pkgs.tmuxPlugins; [
			gruvbox
			tmux-fzf
			mode-indicator
			cmus-tmux
		];
		terminal = "tmux-256color";
		mouse = true;
		extraConfig = (builtins.readFile ./tmux.conf) + ''
run-shell /nix/store/vf642b579fil3zgbbnqzc1vcqgf3yank-tmuxplugin-tmux-cmus-2/share/tmux-plugins/tmux-cmus/tmux-cmus.tmux
run-shell /nix/store/jqlzwm1929y8i808jzrqfpka9lmk13jm-tmuxplugin-mode-indicator-unstable-2021-10-01/share/tmux-plugins/mode-indicator/mode_indicator.tmux
		'';
	};

	programs.fzf = {
		enable = true;
		tmux = {
			enableShellIntegration = true;
			shellIntegrationOptions = [ "-p 80%,35%" ];
		};
	};
}
