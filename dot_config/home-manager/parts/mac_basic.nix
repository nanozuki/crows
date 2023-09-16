{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    git
    zstd
    pinentry_mac
  ];
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
}
