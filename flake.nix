{
  description = "Nix configurations of crows";

  inputs = {
    stable-nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stratosphere = {
      url = "git+https://git.sr.ht/~fubuki/stratosphere";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    {
      darwinConfigurations.raven = nix-darwin.lib.darwinSystem {
        modules = [
          ./overlays.nix
          ./public/modules/darwin
          ./machines/raven
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModule
              ./public/modules/home
            ];
            home-manager.users.crows = ./homes/raven.nix;
            home-manager.extraSpecialArgs = {
              system = "aarch64-darwin";
              clips = import ./public/clips nixpkgs.legacyPackages."aarch64-darwin" "aarch64-darwin";
            };
          }
        ];
        specialArgs = { inherit self inputs; };
      };
      darwinConfigurations.pica = nix-darwin.lib.darwinSystem {
        modules = [
          ./overlays.nix
          ./public/modules/darwin
          ./machines/pica
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModule
              ./public/modules/home
            ];
            home-manager.users.wtang = import ./homes/pica.nix;
            home-manager.extraSpecialArgs = {
              system = "aarch64-darwin";
              clips = import ./public/clips nixpkgs.legacyPackages."aarch64-darwin" "aarch64-darwin";
            };
          }
        ];
        specialArgs = { inherit self inputs; };
      };
      nixosConfigurations.treepie = nixpkgs.lib.nixosSystem {
        modules = [
          ./overlays.nix
          ./machines/treepie/configuration.nix
        ];
        specialArgs = { inherit self inputs; };
      };
    };
}
