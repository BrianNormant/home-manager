{config, pkgs, hostname, ... }: let

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

	imports = [
		./zsh.nix
		./nixvim.nix
	];

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
		cool-retro-term
		usbutils

		neovide
		networkmanagerapplet
		(callPackage ./pep8.nix {})
		hyprpicker
		hyprpanel
		hyprpolkitagent
		waypaper mpvpaper
		libnotify
		libreoffice
		radeontop
		nspire-tools
		wl-clipboard
		xsel

		xournalpp # pdf editor

		zafiro-icons
		libqalculate
	];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
		".config/nvim-simple/init.lua".source = ./nvim-simple.lua;
		".config/lxqt".source = ./lxqt;
		".config/waypaper/config.ini".source = ./config/waypaper/config.ini;
		".config/.tridactylrc".source = ./config/tridactylrc;

		".config/hypr/brightness.nu".source = ./script/brightness.nu;
		".config/hypr/plugged.nu".source = ./script/plugged.nu;
		".config/hypr/volume.nu".source = ./script/volume.nu;
			
		".config/script/media.zsh".text = builtins.readFile ./script/fetch-and-format-media.zsh;
		".config/script/media.zsh".executable = true;

		".config/script/switch-playerctl.zsh".source = ./script/switch-controlled-player.sh;
		".config/script/replay.sh".text = builtins.readFile ./script/replay.sh;
		".config/script/replay.sh".executable = true;

		".config/hypr/hyprlock.conf".text = (import ./hyprlock.nix) (if hostname == "BrianNixDesktop" then "DP-1" else "eDP-1");
		".config/hypr/hypridle.conf".source = ./hypridle.conf;
		".config/hyprpanel/config.json".source = ./config/hyprpanel/hyprpanel.json;

		".config/neovide".source = mkMutableSymlink "${config.home.homeDirectory}/.config/nvim";
		".rmapi".source = mkMutableSymlink "${config.home.homeDirectory}/.config/rmapi/rmapi.conf";
		# "./config/openxr/1/active_runtime.json".source = mkMutableSymlink "~/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json";

		# idris
		".pack/user/pack.toml".source = ./config/idris/pack.toml;

		"OpenComposite".source = "${pkgs.opencomposite}/lib/opencomposite";

		".config/openxr/1/active_runtime-monado.json".text = (import ./config/monado-runtime.json.nix) {inherit (pkgs) monado; };
		".config/openvr/openvrpaths.vrpath.monado".text = (import ./config/openvrpath.json.nix) { inherit (pkgs) opencomposite; };
	};
	home.pointerCursor = {
		name = "phinger-cursors-dark";
		package = pkgs.phinger-cursors;
		size = 32;
		gtk.enable = true;
	};


	systemd.user = (import ./brian-services.nix) pkgs;
	programs = {
		lsd = { enable = true; };
		nushell = {
			enable = true;
			configFile.source = ./config/nushell/default-config.nu;
			extraConfig = with pkgs.nushellPlugins; ''
				plugin add ${polars}/bin/nu_plugin_polars
				'';
		};
		oh-my-posh = {
			enable = false;
			enableZshIntegration = true;
			enableNushellIntegration = true;
			useTheme = "gruvbox";
		};
		kitty = {
			enable = true;
			font = {
				name = "FiraCode Nerd Font Ret";
				package = pkgs.rictydiminished-with-firacode;
				size = 14;
			};
			settings = {
				enable_audio_bell = false;
				confirm_os_window_close = "0";
				# background_opacity = "0.8";
				# dynamic_background_opacity = true;
				# background_tint = "0.0";
				background = "#32302F";
				sync_to_monitor = "no";
			};
			extraConfig = ''
				map alt+F1 set_background_opacity +0.1
				map alt+F2 set_background_opacity -0.1
				'';
		};
		rofi = {
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
		firefox.enable = true;
# Let Home Manager install and manage itself.
		home-manager.enable = true;
		tmux = {
			enable = true;
			clock24 = true;
			escapeTime = 10;
			keyMode = "vi";
			plugins = with pkgs.tmuxPlugins; [
				gruvbox
				mode-indicator
				cmus-tmux
				yank
			];
			terminal = "tmux-256color";
			mouse = true;
			extraConfig = builtins.readFile ./config/tmux.conf;
		};
		fzf = {
			enable = true;
			tmux = {
				enableShellIntegration = true;
				shellIntegrationOptions = [ "-p 80%,35%" ];
			};
		};
		git = {
			enable = true;
			delta.enable = true;
			userEmail = "briannormant@gmail.com";
			userName = hostname;
			extraConfig = {
				push = {
					followTags = "true";
					default = "upstream"; # Push to the tracked branch (see with git branch -vv)
				};
				log.excludeDecoration = "refs/stash";
				merge.tool = "nvim -c \"Git mergetool\"";
				"credential \"https://github.com\"" = {
					helper = "${pkgs.gh} auth git-credential";
				};
				"credential \"https://gist.github.com\"" = {
					helper = "${pkgs.gh} auth git-credential";
				};
				"color \"decorate\"" = {
					HEAD = "blink bold italic 196";
					branch = "214";
					tag = "bold 222";
				};
			};
		};
		ssh = {
			enable = true;
			matchBlocks = {
				"BrianNixDesktop" = {
					hostname = "192.168.2.71";
					port = 4269;
					user = "brian";
				};
				"BrianNixDesktopI" = {
					hostname = "ggkbrian.com";
					port = 4269;
					user = "brian";
				};
				"BrianNixServer" = {
					hostname = "192.168.2.72";
					port = 22;
					user = "server";
				};
				"RootNixServer" = {
					hostname = "192.168.2.72";
					port = 22;
					user = "root";
				};
				"BrianNixLaptop" = {
					hostname = "192.168.2.73";
					port = 4269;
					user = "brian";
				};
			};
		};
	};

	home.file.".config/lsd/icons.yaml".text = ''
extension:
	gnuplot: 
	data: 
	'';
	
	xdg.portal = {
		extraPortals = with pkgs; [
			lxqt.xdg-desktop-portal-lxqt
			xdg-desktop-portal-hyprland
		];
		xdgOpenUsePortal = true;
	};

	wayland.windowManager.hyprland = (import ./hyprland.nix) {
		inherit pkgs;
		inherit hostname;
	};

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

	programs.walker = {
		enable = true;
		runAsService = true;
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
		commandOptions = {
			ignore = [
				# "Name .git"
				"Name .ccls-cache"
				"Name *log*"
				"Name *bin*"
				"Name *.jar"
				"Name result" # nix build output
				"Name target" # maven build output
				"Name .m2"    # maven repo
			];
			repeat = "watch";
			batch = "true";
			ui = "text";
			auto = "true";
			log = "false";
		};
	};
	services.unison.pairs."Wallpapers" = {
		roots = [
			"/home/brian/Wallpapers"
			"ssh://BrianNixDesktopI//home/brian/Wallpapers"
		];
		stateDirectory = "${config.xdg.dataHome}/unison/Wallpapers";
	};
}
