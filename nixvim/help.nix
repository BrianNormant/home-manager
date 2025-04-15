{...}:
let
in {
	programs.nixvim = {
		plugins = {
			helpview = { enable = true; };
		};
	};
}
