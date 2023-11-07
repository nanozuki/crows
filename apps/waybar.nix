{ config, lib, system, ... }: {
  home.file.waybar = {
    enable = lib.hasSuffix system "linux";
    source = ../configs/waybar/config;
    target = "${config.xdg.configHome}/waybar/config";
  };
  home.file.waybar_css = {
    enable = lib.hasSuffix system "linux";
    source = ../configs/waybar/style.css;
    target = "${config.xdg.configHome}/waybar/style.css";
  };
  home.file.waybar_dunst = {
    enable = lib.hasSuffix system "linux";
    source = ../configs/waybar/dunst.sh;
    target = "${config.xdg.configHome}/waybar/dunst.sh";
    executable = true;
  };
}
