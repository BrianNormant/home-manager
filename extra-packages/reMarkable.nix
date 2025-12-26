{
	lib,
	fetchurl,
	stdenvNoCC,
	makeDesktopItem,
	copyDesktopItems,
	wineWowPackages,
	runtimeShell,
	...
}:
let
	icon = fetchurl {
		name = "reMarkable.png";
		url = "https://remarkable.com/favicons/favicon-32x32.png";
		hash = "sha256-eMIuTq7Qc02qSbdubP5WHHsePP+ooBWwNrcprqdgCF8=";
	};
	# We need at least wine 10.17
	wine = wineWowPackages.unstable;
in stdenvNoCC.mkDerivation rec {
		pname = "reMarkable";
		# to check for new version, curl (no redirect) https://downloads.remarkable.com/latest/windows
		version = "3.24.1.1174";
		src = fetchurl {
			url = "https://downloads.remarkable.com/desktop/production/win/reMarkable-${version}-win64.exe";
			hash = "sha256-7F+6+Er/j4rcnyjVp5eAKGE9vGWD+dfXmjAPm4HhOpk=";
		};

		desktopItems = [
			(makeDesktopItem {
				name = "reMarkable";
				exec = "reMarkable";
				icon = "reMarkable";
				desktopName = "reMarkable";
				genericName = "reMarkable";
				categories = [ "Utility" ];
				startupWMClass = "reMarkable";
			})
		];

		nativeBuildInputs = [
			copyDesktopItems
			wine
		];

		dontUnpack = true;
		dontBuild = true;

		installPhase = ''
runHook preInstall
mkdir -p $out/bin
cat <<'EOF' > $out/bin/reMarkable
#!${runtimeShell}
export PATH=${wine}/bin:$PATH
export WINEARCH=win64
export WINEPREFIX="''${REMARKABLE_HOME:-"''${XDG_DATA_HOME:-"''${HOME}/.local/share"}/remarkable"}/wine"
export RM_WINE_EXE="''${WINEPREFIX}/drive_c/Program Files/reMarkable/reMarkable.exe"
export WINEDLLOVERRIDES="mscoree="
if [ ! -d "$WINEPREFIX" ] || [ ! -f "$RM_WINE_EXE" ]; then
	# The has a bad install or has not been executed yet
	mkdir -p "$WINEPREFIX"
	wine ${src} /S
fi

wine "$RM_WINE_EXE"

EOF

chmod +x $out/bin/reMarkable
install -Dm644 ${icon} $out/share/icons/hicolor/32x32/apps/reMarkable.png
runHook postInstall
		'';

		meta = {
			description = "the official reMarkable desktop app";
			homepage = "https://remarkable.com/";
			license = lib.licenses.unfree;
			inherit (wine.meta) platforms;
		};
	}
