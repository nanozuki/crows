{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    zstd
    pinentry_mac
  ];
}
