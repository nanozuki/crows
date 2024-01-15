{ clips, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.apps.git;
in
{
  options.apps.git = { enable = mkEnableOption "git"; };
  config = mkIf cfg.enable {
    home.packages = clips.darwinOr [ pkgs.git ] [ ];
    home.file.git = {
      enable = true;
      source = ../configs/git;
      target = "${config.xdg.configHome}/git";
      recursive = true;
    };
  };
}
