{
  description = "Home Manager configuration of crows";

  inputs = {
    stable-nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    input@{
      self,
      nixpkgs,
      stable-nixpkgs,
      stratosphere,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      stablePackages = [ "awscli2" ];
      stableOverlay =
        final: prev:
        builtins.listToAttrs (
          map (name: {
            name = name;
            value = stable-nixpkgs.legacyPackages.${prev.system}.${name};
          }) stablePackages
        );
      stratosphereOverlay = final: prev: { stra = stratosphere.packages.${prev.system}; };
      pkgModule =
        { ... }:
        {
          nixpkgs.overlays = [
            input.rust-overlay.overlays.default
            stableOverlay
            stratosphereOverlay
          ];
          nixpkgs.config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
          };
        };
    in
    {
      darwinConfigurations."raven" = nix-darwin.lib.darwinSystem {
        modules = [
          pkgModule
          ./modules/darwin
          ./machines/raven
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              input.sops-nix.homeManagerModule
              ./homes/raven.nix
              ./modules
            ];
            # home-manager.users."raven" = ./homes/raven.nix;
            home-manager.extraSpecialArgs = {
              system = "aarch64-darwin";
              clips = import ./clips nixpkgs.legacyPackages."aarch64-darwin" "aarch64-darwin";
            };
          }
        ];
        specialArgs = { inherit self; };
      };
      darwinConfigurations."pica" = nix-darwin.lib.darwinSystem {
        modules = [
          pkgModule
          ./modules/darwin
          ./machines/pica
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              input.sops-nix.homeManagerModule
              ./homes/pica.nix
              ./modules
            ];
            # home-manager.users."pica" = ./homes/pica.nix;
            home-manager.extraSpecialArgs = {
              system = "aarch64-darwin";
              clips = import ./clips nixpkgs.legacyPackages."aarch64-darwin" "aarch64-darwin";
            };
          }
        ];
        specialArgs = { inherit self; };
      };
    };
}
