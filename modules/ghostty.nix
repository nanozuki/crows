{ clips, config, lib, pkgs, ... }:
with lib;
let cfg = config.apps.ghostty;
in
{
  options.apps.ghostty = { enable = mkEnableOption "ghostty"; };
  config = mkIf cfg.enable {
    home.packages = clips.darwinOr [ ] [ pkgs.ghostty ];
    home.file.ghostty = {
      enable = true;
      source = ../configs/ghostty/config;
      target = "${config.xdg.configHome}/ghostty/config";
    };
  };
}
