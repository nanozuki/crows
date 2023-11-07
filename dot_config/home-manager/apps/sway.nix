{ config, lib, system, ... }: {
  home.file.sway_config = {
    enable = lib.hasSuffix system "linux";
    source = ../configs/sway/config;
    target = "${config.xdg.configHome}/sway/config";
  };
  home.file.sway_menu = {
    enable = lib.hasSuffix system "linux";
    source = ../configs/sway/swaymenu.sh;
    target = "${config.home.homeDirectory}/.local/bin/swaymenu.sh";
    executable = true;
  };
}
