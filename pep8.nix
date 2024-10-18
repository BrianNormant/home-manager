{pkgs}: pkgs.stdenv.mkDerivation rec {
	pname = "pep8-asm";
	version = "8.3";
	src = pkgs.fetchFromGitHub {
		owner = "StanWarford";
		repo = "pep8";
		rev = "v${version}";
		hash = "sha256-VgXjHETMCh42PZiluiTDtXJqVv3pLqSMr78sE7PMDUs=";
	};
# dontWrapQtApps = true;
	nativeBuildInputs = with pkgs; [
		qt5.wrapQtAppsHook
		makeWrapper
	];
	buildInputs = with pkgs; [
		qt5.qtbase
		libsForQt5.qt5.qtwebengine
	];
	buildPhase = ''
		qmake pep8.pro
		make -j $(nproc)
	'';
	installPhase = ''
		mkdir -p $out/bin
		cp Pep8 $out/bin/pep8
	'';
	postFixup = ''
	wrapProgram $out/bin/pep8 \
	--set QT_QPA_PLATFORM wayland
	'';
}
