{
	buildGoModule,
	fetchFromGitHub,
	lib,
}:
buildGoModule rec {
	pname = "rpn";
	version = "1.0.2";

	src = fetchFromGitHub {
	  owner = "marcopaganini";
	  repo = "rpn";
	  rev = "v${version}";
	  hash = "sha256-Gkkuem9Z2HUakSFNpF49EkQBMsj0mRE6M+3vdJHn/0w=";
	};

	vendorHash = "sha256-ATiaMryj/1vRqDG5WKk8LtIQVgTqzF8rlgTKZVTjv6s=";

	meta = with lib;{
		description = "RPN calculator";
		homepage = "https://github.com/marcopaganini/rpn";
		license = licenses.mit;
		maintainers = [ ];
	};
}
