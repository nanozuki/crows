# Crows

My dotfiles and public nix modules.

- `configs/`: dotfiles
- `modules`/: nix modules

## Example flake.nix

```nix
{
  description = "Nix configurations of crows";

  inputs = {
    stable-nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-<stable-version>";
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
      darwinConfigurations.<profile-name> = nix-darwin.lib.darwinSystem {
        modules = [
          ./overlays.nix
          ./modules/darwin
          ./machines/<machine-name>.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModule
              ./modules/home
            ];
            home-manager.users.<user-name> = ./homes/<profile-name>.nix;
            home-manager.extraSpecialArgs = {
              system = "aarch64-darwin";
              clips = import ./clips nixpkgs.legacyPackages."aarch64-darwin" "aarch64-darwin";
            };
          }
        ];
        specialArgs = { inherit self inputs; };
      };
    };
}
```
