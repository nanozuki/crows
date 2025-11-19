{
  clips,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.apps.ghostty;
  # choose themes by comman "ghostty +list-themes"
  themeSet = {
    "rose-pine/main" = "Rose Pine";
    "rose-pine/dawn" = "Rose Pine Dawn";
    "rose-pine/moon" = "Rose Pine Moon";
    "nord/main" = "Nord";
    "zenbones/light" = "Zenbones";
    "zenbones/dark" = "Zenbones Dark";
  };
  vars = {
    theme = themeSet."${config.g.theme.name}/${config.g.theme.variant}";
  };
in
{
  options.apps.ghostty = {
    enable = mkEnableOption "ghostty";
  };
  config = mkIf cfg.enable {
    home.packages = clips.darwinOr [ ] [ pkgs.ghostty ];
    home.file.ghostty = {
      enable = true;
      source = clips.mustache "config" ../configs/ghostty/config vars;
      target = "${config.xdg.configHome}/ghostty/config";
    };
  };
}
