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
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };
  outputs = inputs@{ nixpkgs, home-manager, blink-cmp, hyprpanel, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
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
          hyprpanel.overlay
        ];
      };
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
