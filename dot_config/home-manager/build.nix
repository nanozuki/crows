{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-update
    yarn2nix
  ];
}
