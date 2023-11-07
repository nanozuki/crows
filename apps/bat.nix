{ config, pkgs, ... }: {
  home.packages = [ pkgs.bat ];
  home.file.bat = {
    enable = true;
    source = ../configs/bat/config;
    target = "${config.xdg.configHome}/bat/config";
  };
}
