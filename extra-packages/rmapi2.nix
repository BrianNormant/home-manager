{pkgs, ...}:pkgs.rmapi.overrideAttrs (old: rec {
	version = "v0.0.35";
	src = pkgs.fetchFromGitHub {
		owner = "ddvk";
		repo = "rmapi";
		rev = "${version}";
		hash = "sha256-mRJH0fQ8e4igR7IwcJdvUhrZDXvpTt/Dac7Pc9p7ITw=";
	};
})
