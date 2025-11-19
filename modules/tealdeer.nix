{
  clips,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.apps.tealdeer;
in
{
  options.apps.tealdeer = {
    enable = mkEnableOption "tealdeer";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.tealdeer ];
    home.file.tealdeer = {
      enable = true;
      text = ''
        [updates]
          auto_update = true
          auto_update_interval_hours = 24
      '';
      target = clips.darwinOr "${config.home.homeDirectory}/Library/Application Support/tealdeer/config.toml" "${config.xdg.configHome}/tealdeer/config.toml";
    };
  };
}
