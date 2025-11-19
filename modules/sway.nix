{ config, lib, ... }:
with lib;
let
  cfg = config.apps.sway;
in
{
  options.apps.sway = {
    enable = mkEnableOption "sway";
  };
  config = mkIf cfg.enable {
    home.file.sway_config = {
      enable = true;
      source = ../configs/sway/config;
      target = "${config.xdg.configHome}/sway/config";
    };
    home.file.sway_menu = {
      enable = true;
      source = ../configs/sway/swaymenu.sh;
      target = "${config.home.homeDirectory}/.local/bin/swaymenu.sh";
      executable = true;
    };
  };
}
