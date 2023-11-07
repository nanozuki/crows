{
  description = "Home Manager configuration of crows";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
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

  outputs = { nixpkgs, home-manager, stratosphere, rust-overlay, sops-nix, ... }:
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
            home
          ];
          extraSpecialArgs = {
            spkgs = stratosphere.packages.${system};
            inherit system;
            inherit vars; # variables for customizing
          };
        };
    in
    {
      homeConfigurations.pica = homeConfig ./hosts/pica.nix "x86_64-linux" {
        fontSize = 14;
        fontFamily = "JetBrainsMonoNL Nerd Font";
      };
      homeConfigurations.raven = homeConfig ./hosts/raven.nix "aarch64-darwin" {
        fontSize = 14;
        fontFamily = "JetBrainsMonoNL Nerd Font";
      };
      homeConfigurations.nest = homeConfig ./hosts/nest.nix "x86_64-linux" {
        fontSize = 14;
        fontFamily = "JetBrainsMonoNL Nerd Font";
      };
    };
}
