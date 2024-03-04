{
  description = "Home Manager configuration of crows";

  inputs = {
    stable-nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
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
      inputs.nixpkgs-stable.follows = "stable-nixpkgs";
    };
  };

  outputs = { nixpkgs, stable-nixpkgs, stratosphere, home-manager, rust-overlay, sops-nix, ... }:
    let
      stablePackages = [ ];
      stableOverlay = final: prev:
        builtins.listToAttrs
          (map
            (name: { name = name; value = stable-nixpkgs.legacyPackages.${prev.system}.${name}; })
            stablePackages);
      stratosphereOverlay = final: prev: { stra = stratosphere.packages.${prev.system}; };
      homeConfig = home: system: vars:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ({ pkgs, ... }: {
              nixpkgs.overlays = [
                rust-overlay.overlays.default
                stableOverlay
                stratosphereOverlay
              ];
              nixpkgs.config = { allowUnfree = true; allowUnfreePredicate = (_: true); };
            })
            sops-nix.homeManagerModule
            ./modules
            home
          ];
          extraSpecialArgs = {
            inherit system;
            inherit vars; # variables for customizing
            clips = import ./clips nixpkgs.legacyPackages.${system} system;
          };
        };
    in
    {
      homeConfigurations = builtins.mapAttrs
        (host: config: homeConfig config.homeConfig config.system config.vars)
        (import ./hosts);
    };
}
