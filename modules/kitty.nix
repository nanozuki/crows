{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.apps.kitty;
  # choose themes by comman "kitten themes"
  themeSet = {
    "rose-pine/main" = "Rosé Pine";
    "rose-pine/dawn" = "Rosé Pine Dawn";
    "rose-pine/moon" = "Rosé Pine Moon";
    "nord/main" = "Nord";
    "zenbones/light" = "zenbones_light";
    "zenbones/dark" = "zenbones_dark";
    "zenbones/rose-light" = "Rosé Pine Dawn";
    "zenbones/rose-dark" = "Rosé Pine";
  };
in
{
  options.apps.kitty = { enable = mkEnableOption "kitty"; };
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
      theme = themeSet."${config.g.theme.name}/${config.g.theme.variant}";
    };
    home.file.kitty = {
      enable = true;
      source = ../configs/kitty/kitty.app.png;
      recursive = true;
      target = "${config.xdg.configHome}/kitty/kitty.app.png";
    };
  };
}
