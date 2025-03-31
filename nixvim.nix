{config, pkgs, ...}: {
	imports = [
		# Add configuration from ./nixvim/*.nix
	];

	programs.nixvim = {
		enable = true;
	};
}
