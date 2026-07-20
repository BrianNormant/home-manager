{pkgs, ...}:pkgs.rmapi.overrideAttrs (old: rec {
	version = "v0.0.34";
	src = pkgs.fetchFromGitHub {
		owner = "ddvk";
		repo = "rmapi";
		rev = "${version}";
		hash = "sha256-g7KFLa+VBkubzdrgMFDVvAuscw41nyfHd7DWvh3S+NU=";
	};
})
