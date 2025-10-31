{pkgs, ...}:
let
	qml-niri = pkgs.stdenv.mkDerivation rec {
		pname = "qml-niri";
		version = "7694e28";
		src = pkgs.fetchFromGitHub {
			owner = "imiric";
			repo = "qml-niri";
			rev = "${version}";
			hash = "sha256-O9cMtAMcGGVA0qkOvim6D+7CA0w1DvyVYUlJpNKp/A0=";
		};
		dontWrapQtApps = true;
		nativeBuildInputs = with pkgs; [
			cmake
			gnumake
			qt6.qtbase
			qt6.qtwayland
		];
		outputs = [ "out" ];
		buildPhase = ''
			cmake .
			make
		'';
		installPhase = ''
			mkdir -p $out/lib/qml
			cp -r Niri $out/lib/qml
		'';
	};
	qml-caelestia = pkgs.stdenv.mkDerivation rec {
		pname = "qml-caelestia";
		version = "210e0b6";
		src = pkgs.fetchFromGitHub {
	 		owner = "BrianNormant";
			repo = "shell";
			rev = "${version}";
			hash = "sha256-Y7JEdMOz3DKQTCm0KZLjg0AQATlUpnHtyJCyxNTEYXo=";
		};
		dontWrapQtApps = true;
		nativeBuildInputs = with pkgs; [
			cmake
			gnumake
			pkg-config
			qt6.qtbase
			qt6.qtwayland
			libqalculate
			pipewire
			aubio
			libcava
			fftw
		];
		cmakeFlags =
			[
				(pkgs.lib.cmakeFeature "ENABLE_MODULES" "plugin")
				(pkgs.lib.cmakeFeature "INSTALL_QMLDIR" pkgs.qt6.qtbase.qtQmlPrefix)
				(pkgs.lib.cmakeFeature "VERSION" "3.20")
				(pkgs.lib.cmakeFeature "GIT_REVISION" version)
				(pkgs.lib.cmakeFeature "DISTRIBUTOR" "nix-flake")
			];
	};
in {
	programs.quickshell = {
		enable = true;
		# package = pkgs.quickshell.overrideAttrs (prev: (next: {
		# 	src = pkgs.fetchFromGitea {
		# 		domain = "git.outfoxxed.me";
		# 		owner = "quickshell";
		# 		repo = "quickshell";
		# 		rev = "1b147a2c";
		# 		hash = "sha256-G16tcvlv9tHqrNQB8UTtdqTd6jur9wNuik1Kx6NDH5Y=";
		# 	};
		# }));
	};
	home.packages = with pkgs; [
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
		caelestia-cli
	];
	home.file = {
		".config/quickshell/shell.qml".source = ./config/quickshell/shell.qml;
		".config/quickshell/components".source = ./config/quickshell/components;
		".config/quickshell/config".source = ./config/quickshell/config;
		".config/quickshell/modules".source = ./config/quickshell/modules;
		".config/quickshell/services".source = ./config/quickshell/services;
		".config/quickshell/utils".source = ./config/quickshell/utils;
		".config/quickshell/assets/shaders".source = ./config/quickshell/assets/shaders;
		".config/quickshell/assets/bongocat.gif".source = ./config/quickshell/assets/bongocat.gif;
		".config/quickshell/assets/dino.png".source = ./config/quickshell/assets/dino.png;
		".config/quickshell/assets/kurukuru.gif".source = ./config/quickshell/assets/kurukuru.gif;
		".config/quickshell/assets/logo.svg".source = ./config/quickshell/assets/logo.svg;
		".config/quickshell/assets/wrap_term_launch.sh".source = ./config/quickshell/assets/wrap_term_launch.sh;

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
	home.sessionVariables."QML_IMPORT_PATH" = "${qml-niri}/lib/qml/:${qml-caelestia}/lib/qt-6/qml/";
	programs.zsh.sessionVariables."QML_IMPORT_PATH" = "${qml-niri}/lib/qml/:${qml-caelestia}/lib/qt-6/qml/";
	fonts.fontconfig = { enable = true; };
}
