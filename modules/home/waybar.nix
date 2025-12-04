{ config, lib, ... }:
with lib;
let
  cfg = config.crows.waybar;
in
{
  options.crows.waybar = {
    enable = mkEnableOption "waybar";
  };
  config = mkIf cfg.enable {
    home.file.waybar = {
      enable = true;
      source = ../../configs/waybar/config;
      target = "${config.xdg.configHome}/waybar/config";
    };
    home.file.waybar_css = {
      enable = true;
      source = ../../configs/waybar/style.css;
      target = "${config.xdg.configHome}/waybar/style.css";
    };
    home.file.waybar_dunst = {
      enable = true;
      source = ../../configs/waybar/dunst.sh;
      target = "${config.xdg.configHome}/waybar/dunst.sh";
      executable = true;
    };
  };
}
