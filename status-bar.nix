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
in {
	programs.quickshell = {
		enable = true;
	};
	home.packages = with pkgs; [
		quickshell
		material-symbols
		ibm-plex
		lm_sensors
		grim
		swappy
		libqalculate
		nerd-fonts.jetbrains-mono
		brightnessctl
		ddcutil
		cava
		app2unit
		aubio
		fish
		qml-niri
	];
	home.file = {
		".config/quickshell".source = ./config/quickshell;
	};
	home.sessionVariables."QML_IMPORT_PATH" = "${qml-niri}/lib/qml/";
	fonts.fontconfig = { enable = true; };
}
