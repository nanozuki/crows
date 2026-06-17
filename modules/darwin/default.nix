{ inputs, ... }:
{
  imports = [
    ./home.nix
    ./vimr.nix
  ];

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
