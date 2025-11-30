{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.bat;
in
{
  options.crows.bat = {
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
