{ config, lib, ... }:
with lib;
let
  cfg = config.crows.sway;
in
{
  options.crows.sway = {
    enable = mkEnableOption "sway";
  };
  config = mkIf cfg.enable {
    home.file.sway_config = {
      enable = true;
      source = ../../configs/sway/config;
      target = "${config.xdg.configHome}/sway/config";
    };
    home.file.sway_menu = {
      enable = true;
      source = ../../configs/sway/swaymenu.sh;
      target = "${config.home.homeDirectory}/.local/bin/swaymenu.sh";
      executable = true;
    };
  };
}
