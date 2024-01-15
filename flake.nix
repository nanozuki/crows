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
    rust-overlay.url = "github:oxalica/rust-overlay";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, stable-nixpkgs, stratosphere, home-manager, rust-overlay, sops-nix, ... }:
    let
      stablePackages = [ "deno" "btop" ];
      stableOverlay = final: prev:
        builtins.listToAttrs
          (map
            (name: { name = name; value = stable-nixpkgs.legacyPackages.${prev.system}.${name}; })
            stablePackages);
      stratosphereOverlay = final: prev: { stra = stratosphere.packages.${prev.system}; };
      clips = import ./clips/clips.nix;
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
            ./modules/modules.nix
            home
          ];
          extraSpecialArgs = {
            inherit system;
            inherit vars; # variables for customizing
            clips = clips vars.hostId nixpkgs.legacyPackages.${system} system;
          };
        };
    in
    {
      homeConfigurations.pica = homeConfig ./hosts/pica.nix "aarch64-darwin" {
        hostId = "pica";
        font = {
          family = "JetBrains Mono NL";
          size = 14;
        };
        theme = {
          name = "rose-pine";
          variant = "dawn";
        };
      };
      homeConfigurations.raven = homeConfig ./hosts/raven.nix "aarch64-darwin" {
        hostId = "raven";
        font = {
          family = "JetBrains Mono NL";
          size = 14;
        };
        theme = {
          name = "rose-pine";
          variant = "dawn";
        };
      };
      homeConfigurations.nest = homeConfig ./hosts/nest.nix "x86_64-linux" {
        hostId = "nest";
        font = {
          family = "JetBrains Mono NL";
          size = 12;
        };
        theme = {
          name = "rose-pine";
          variant = "dawn";
        };
      };
    };
}
