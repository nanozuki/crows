{ inputs, ... }:
{
  imports = [
    ./home.nix
  ];

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
