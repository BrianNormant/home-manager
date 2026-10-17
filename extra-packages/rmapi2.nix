{pkgs, ...}:pkgs.rmapi.overrideAttrs (old: rec {
	version = "aa60dac";
	src = pkgs.fetchFromGitHub {
		owner = "ddvk";
		repo = "rmapi";
		rev = "${version}";
		hash = "sha256-AP6ba2lUZAAowtmX52zC97HI8U9nvbd8HyUqMqdxA2o=";
	};
})
