{pkgs, ...}:
let
	inherit (pkgs) vimUtils fetchFromGitHub;
in vimUtils.buildVimPlugin {
		pname = "spring-boot";
		version = "HEAD";
		src = fetchFromGitHub {
			owner = "JavaHello";
			repo = "spring-boot.nvim";
			rev = "dff5fc9";
			hash = "sha256-WAgxEtVSAkFzDMNymuO/1p9Wz8bvSbY/oue+1Sl6Oio=";
		};
	}
