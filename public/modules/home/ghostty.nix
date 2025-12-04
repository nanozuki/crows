{
  clips,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.ghostty;
  themeOptionValues = {
    "rose-pine" = "light:Rose Pine Dawn,dark:Rose Pine";
    "zonbones" = "light:Zenbones,dark:Zenbones Dark";
  };
  vars = {
    theme = themeOptionValues.${config.g.theme.name};
  };
in
{
  options.crows.ghostty = {
    enable = mkEnableOption "ghostty";
  };
  config = mkIf cfg.enable {
    home.packages = clips.darwinOr [ ] [ pkgs.ghostty ];
    home.file.ghostty = {
      enable = true;
      source = clips.mustache "config" ../../configs/ghostty/config vars;
      target = "${config.xdg.configHome}/ghostty/config";
    };
  };
}
