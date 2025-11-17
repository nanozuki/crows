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
        { pkgs, ... }:
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
      mkHome =
        home: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            pkgModule
            input.sops-nix.homeManagerModule
            ./modules
            home
          ];
          extraSpecialArgs = {
            inherit system;
            clips = import ./clips nixpkgs.legacyPackages.${system} system;
          };
        };
    in
    {
      homeConfigurations = {
        pica = mkHome ./homes/pica.nix "aarch64-darwin";
        raven = mkHome ./homes/raven.nix "aarch64-darwin";
      };
      darwinConfigurations."raven" = nix-darwin.lib.darwinSystem {
        modules = [
          ./modules/darwin
          ./machines/raven
        ];
        specialArgs = { inherit self; };
      };
      darwinConfigurations."pica" = nix-darwin.lib.darwinSystem {
        modules = [
          ./modules/darwin
          ./machines/pica
        ];
        specialArgs = { inherit self; };
      };
    };
}
