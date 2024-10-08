{
  description = "Home Manager configuration of brian";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blink-cmp.url = "github:Saghen/blink.cmp";
  };

  outputs = inputs@{ nixpkgs, home-manager, blink-cmp, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      blink = blink-cmp.packages."${system}".blink-cmp;
    in {
      homeConfigurations."brian@BrianNixDesktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
		extraSpecialArgs = {hostname = "BrianNixDesktop"; inherit blink;};
      };
      homeConfigurations."brian@BrianNixLaptop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
		extraSpecialArgs = {hostname = "BrianNixLaptop"; inherit inputs; inherit blink;};
      };
    };
}
