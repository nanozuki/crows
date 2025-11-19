{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.apps.kitty;
  # choose themes by comman "kitten themes"
  themeSet = {
    "rose-pine/main" = "rose-pine";
    "rose-pine/dawn" = "rose-pine-dawn";
    "rose-pine/moon" = "rose-pine-moon";
    "nord/main" = "Nord";
    "zenbones/light" = "zenbones_light";
    "zenbones/dark" = "zenbones_dark";
  };
in
{
  options.apps.kitty = {
    enable = mkEnableOption "kitty";
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = pkgs.emptyDirectory;
      font.name = config.g.font.family;
      font.size = config.g.font.size;
      extraConfig = builtins.readFile ../configs/kitty/kitty.conf;
      shellIntegration = {
        enableFishIntegration = true;
        mode = "no-cursor";
      };
      themeFile = themeSet."${config.g.theme.name}/${config.g.theme.variant}";
    };
    home.file.kitty = {
      enable = true;
      source = ../configs/kitty/kitty.app.png;
      recursive = true;
      target = "${config.xdg.configHome}/kitty/kitty.app.png";
    };
  };
}
