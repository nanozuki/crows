{
  description = "Home Manager configuration of crows";

  inputs = {
    stable-nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
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
      homeConfig = home: system: vars:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
              nixpkgs.config = {
                allowUnfree = true;
                allowUnfreePredicate = (_: true);
              };
            })
            sops-nix.homeManagerModule
            ./modules/modules.nix
            home
          ];
          extraSpecialArgs = {
            sspkgs = stratosphere.packages.${system}; # StratoSphere packages
            stpkgs = stable-nixpkgs.legacyPackages.${system}; # STable packages
            inherit system;
            inherit vars; # variables for customizing
          };
        };
    in
    {
      homeConfigurations.pica = homeConfig ./hosts/pica.nix "aarch64-darwin" {
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
