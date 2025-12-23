{
	description = "Home Manager configuration of brian";

	inputs = {
		self.submodules = true;
# Specify the source of Home Manager and Nixpkgs.
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nspire-tools.url = "github:BrianNormant/nspire-tools";
		autoeq.url = "github:BrianNormant/autoeq";
		nixvim = {
			url = "github:nix-community/nixvim";
			# inputs.nixpkgs.follows = "nixpkgs";
		};
		caelestia-cli = {
			url = "github:caelestia-dots/cli";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		my-quickshell = {
			url = ./config/quickshell;
			inputs.nixpkgs.follows = "nixpkgs";
		};
		quickshell = {
			url = "github:quickshell-mirror/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		qml-niri = {
			url = "github:imiric/qml-niri/main";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.quickshell.follows = "quickshell";
		};
	};
	outputs = inputs@{ nixpkgs, home-manager, nspire-tools,
		 ... }:
		let
	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
		overlays = [
			(final: prev: with prev.lib;
				builtins.readDir ./extra-packages
				|> mapAttrs' (v: _: nameValuePair
						(removeSuffix ".nix" v)
						(import ./extra-packages/${v} {pkgs = prev;} )
					)
			)
			(final: prev: {
				vimPlugins = prev.vimPlugins.extend (f': p': with prev.lib;
					builtins.readDir ./extra-nvim-packages
					|> mapAttrs' (v: _: nameValuePair
							(removeSuffix ".nix" v)
							(prev.callPackage ./extra-nvim-packages/${v} {})
						)
				);
			})
			inputs.nixpkgs-xr.overlays.default
			inputs.autoeq.overlays.default
			(f: p: {inherit (inputs.quickshell.packages."${system}") quickshell;})
			(f: p: {qml-niri = inputs.qml-niri.packages."${system}".default;})
			(f: p: {inherit (inputs.my-quickshell.packages."${system}") qml-caelestia;})
			(f: p: {nspire-tools = nspire-tools.packages."${system}".default;})
			(f: p: {inherit (inputs.caelestia-cli.packages."${system}") caelestia-cli;})
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
