{
	description = "Home Manager configuration of brian";

	inputs = {
		self.submodules = true;
# Specify the source of Home Manager and Nixpkgs.
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nspire-tools.url = "github:BrianNormant/nspire-tools";
		nixd.url = "github:nix-community/nixd?ref=2.6.2";
		autoeq.url = "github:BrianNormant/autoeq";
		nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		caelestia-cli = {
			url = "github:caelestia-dots/cli";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		quickshell = {
			url = "github:quickshell-mirror/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = inputs@{ nixpkgs, home-manager, nspire-tools, nixd, quickshell, caelestia-cli, ... }:
		let
	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
		overlays = [
			inputs.autoeq.overlays.default
			(final: prev: {
			 matugen = final.rustPlatform.buildRustPackage rec {
			 pname = "matugen";
			 version = "2.4.0";

			 src = final.fetchFromGitHub {
			 owner = "InioX";
			 repo = "matugen";
			 rev = "refs/tags/v${version}";
			 hash = "sha256-l623fIVhVCU/ylbBmohAtQNbK0YrWlEny0sC/vBJ+dU=";
			 };

			 cargoHash = "sha256-FwQhhwlldDskDzmIOxhwRuUv8NxXCxd3ZmOwqcuWz64=";

			 meta = {
			 description = "Material you color generation tool";
			 homepage = "https://github.com/InioX/matugen";
			 changelog = "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
			 license = final.lib.licenses.gpl2Only;
			 maintainers = with final.lib.maintainers; [ lampros ];
			 mainProgram = "matugen";
			 };
			 };
			})
			(final: prev: {nspire-tools = nspire-tools.packages."${system}".default;})
			(final: prev: {inherit (nixd.packages."${system}") nixd nixf nixt;})
			# (final: prev: {
			# 	xrizer = prev.xrizer.overrideAttrs {
			# 		src = final.fetchFromGitHub {
			# 			owner = "BrianNormant";
			# 			repo = "xrizer";
			# 			rev = "e61217c";
			# 			hash = "sha256-5IqiDYYF5SLlbOpACOlqw7FrmrQYyaZGDhxGC9a73aU=";
			# 		};
			# 		cargoHash = "";
			# 		version = "0.3.0";
			# 	};
			# })
			(final: prev: {inherit (caelestia-cli.packages."${system}") caelestia-cli;})
			(final: prev: {inherit (quickshell.packages."${system}") quickshell;})
			];
	};
	modules = with inputs; [
		./home.nix
		nixvim.homeModules.default
	];
	in {
		homeConfigurations."brian@BrianNixDesktop" = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			inherit modules;

# Optionally use extraSpecialArgs
# to pass through arguments to home.nix
			extraSpecialArgs = {hostname = "BrianNixDesktop";};
		};
		homeConfigurations."brian@BrianNixLaptop" = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			inherit modules;

# Optionally use extraSpecialArgs
# to pass through arguments to home.nix
			extraSpecialArgs = {hostname = "BrianNixLaptop";};
		};
	};
}
