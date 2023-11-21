{ config, lib, pkgs, system, ... }:
with lib;
let
  cfg = config.apps.git;
  darwinOr = import ../clips/darwin-or.nix system;
in
{
  options.apps.git = { enable = mkEnableOption "git"; };
  config = mkIf cfg.enable {
    home.packages = darwinOr [ pkgs.git ] [ ];
    home.file.git = {
      enable = true;
      source = ../configs/git;
      target = "${config.xdg.configHome}/git";
      recursive = true;
    };
  };
}
