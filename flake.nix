{
	description = "Home Manager configuration of brian";

	inputs = {
# Specify the source of Home Manager and Nixpkgs.
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nspire-tools.url = "github:BrianNormant/nspire-tools";
		autoeq.url = "github:BrianNormant/autoeq";
		nvim-cat = {
			url = "github:BrianNormant/nvim-cat";
		};
		niri-caelestia = {
			url = "github:BrianNormant/niri-caelestia-shell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		awww = {
			url = "git+https://codeberg.org/LGFae/awww";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = inputs@{ nixpkgs, home-manager, ... }:
		let
	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
		overlays = [
			(next: prev:
					let callPackage = prev.lib.callPackageWith prev;
					 in with prev.lib;
				builtins.readDir ./extra-packages
				|> mapAttrs' (v: _: nameValuePair
						(removeSuffix ".nix" v)
						(callPackage ./extra-packages/${v} {})
					)
			)
			(next: prev:
					let callPackage = prev.lib.callPackageWith prev;
					 in with prev.lib; {
				vimPlugins = prev.vimPlugins.extend (f': p': with prev.lib;
					builtins.readDir ./extra-nvim-packages
					|> mapAttrs' (v: _: nameValuePair
							(removeSuffix ".nix" v)
							(callPackage ./extra-nvim-packages/${v} {})
						)
				);
			})
			inputs.nixpkgs-xr.overlays.default
			inputs.autoeq.overlays.default
			inputs.nvim-cat.overlays.default
			inputs.awww.overlays.default # This is stupid but it makes it able to have 2 of the same
			# wallpaper engine on the niri backdrop (overview) and as regular background
			(f: p: {nspire-tools    = inputs.nspire-tools.packages."${system}".default;})
			(f: p: {caelestia-shell = inputs.niri-caelestia.packages."${system}".default;})
			(f: p: {caelestia-qs = inputs.niri-caelestia.packages."${system}".quickshell-p;})
			];
	};
	programs-modules = pkgs.lib.filesystem.listFilesRecursive ./programs;
	services-modules = pkgs.lib.filesystem.listFilesRecursive ./services;
	modules = with inputs; [
		./home.nix
		./homeconfig.nix
	] ++ programs-modules ++ services-modules;
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
