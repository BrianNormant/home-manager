{pkgs, ...}:
{
	programs.quickshell = {
		enable = true;
	};
	home = {
		packages = with pkgs; [
			material-symbols
			ibm-plex
			lm_sensors
			grim
			swappy
			libqalculate
			nerd-fonts.jetbrains-mono		brightnessctl
			ddcutil
			cava
			app2unit
			aubio
			fish
			qml-niri
			qml-caelestia
			gpu-screen-recorder
			swaylock # unlock if the quickshell crashes
			# caelestia-cli
		];
		file = {
			".local/state/caelestia/scheme.json".source = ../config/quickshell-scheme.json;
			".config/quickshell/shell.qml".source = ../config/quickshell/shell.qml;
			".config/quickshell/components".source = ../config/quickshell/components;
			".config/quickshell/config".source = ../config/quickshell/config;
			".config/quickshell/modules".source = ../config/quickshell/modules;
			".config/quickshell/services".source = ../config/quickshell/services;
			".config/quickshell/utils".source = ../config/quickshell/utils;
			".config/quickshell/assets/shaders".source = ../config/quickshell/assets/shaders;
			".config/quickshell/assets/bongocat.gif".source = ../config/quickshell/assets/bongocat.gif;
			".config/quickshell/assets/dino.png".source = ../config/quickshell/assets/dino.png;
			".config/quickshell/assets/kurukuru.gif".source = ../config/quickshell/assets/kurukuru.gif;
			".config/quickshell/assets/logo.svg".source = ../config/quickshell/assets/logo.svg;
			".config/quickshell/assets/wrap_term_launch.sh".source = ../config/quickshell/assets/wrap_term_launch.sh;

			".config/quickshell/assets/pam.d/fprint".text = ''
	auth required ${pkgs.fprintd}/lib/security/pam_fprintd.so max-tries=1
			'';
			".config/quickshell/assets/pam.d/passwd".text = ''
	auth required ${pkgs.pam}/lib/security/pam_faillock.so preauth
	auth [success=1 default=bad] ${pkgs.pam}/lib/security/pam_unix.so nullok
	auth [default=die] ${pkgs.pam}/lib/security/pam_faillock.so authfail
	auth required ${pkgs.pam}/lib/security/pam_faillock.so authsucc
			'';
		};
		sessionVariables."QML_IMPORT_PATH" = with pkgs;
			"${qml-niri}/lib/qt-6/qml/:${qml-caelestia}/lib/qt-6/qml/";
	};

	# Make QML plugins available to quickshell
	programs.zsh.sessionVariables."QML_IMPORT_PATH" = with pkgs;
		"${qml-niri}/lib/qt-6/qml/:${qml-caelestia}/lib/qt-6/qml/";
	fonts.fontconfig = { enable = true; };
}
