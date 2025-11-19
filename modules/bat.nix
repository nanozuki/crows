{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.apps.bat;
in
{
  options.apps.bat = {
    enable = mkEnableOption "bat";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.bat ];
    home.file.bat = {
      enable = true;
      source = ../configs/bat/config;
      target = "${config.xdg.configHome}/bat/config";
    };
  };
}
