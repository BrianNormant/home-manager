{pkgs}: pkgs.stdenv.mkDerivation {
	name = "wl-shimeji";
	src = pkgs.fetchFromGitHub {
		owner = "CluelessCatBurger";
		repo = "wl_shimeji";
		rev = "bf0150a";
		hash = "sha256-ag3MHyyfo+2yZxPSBZgBsVZ4a6nLSv1KMUcYS34lIiM=";
		fetchSubmodules = true;
	};
	buildInputs = with pkgs; [
		gnumake
		pkg-config
		which

		wayland
		wayland-scanner
		wayland-protocols
		libarchive
		uthash

		makeWrapper
	];
	propagatedBuildInputs = [
		(pkgs.python3.withPackages (py-pkgs: [py-pkgs.pillow]))
	];
	buildPhase = ''
		make -j1
	'';
	installPhase = ''
		mkdir $out
		export DESTDIR=$out
		export PREFIX=""
		make install
	'';
}
