{ config, lib, pkgs, vars, ... }:
with lib;
let
  cfg = config.apps.kitty;
  themeSet = {
    "rose-pine/main" = "Rosé Pine";
    "rose-pine/dawn" = "Rosé Pine Dawn";
    "rose-pine/moon" = "Rosé Pine Moon";
  };
in
{
  options.apps.kitty = { enable = mkEnableOption "kitty"; };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = pkgs.hello; # ignore package
      font.name = vars.font.family;
      font.size = vars.font.size;
      extraConfig = builtins.readFile ../configs/kitty/kitty.conf;
      shellIntegration.enableFishIntegration = true;
      theme = themeSet."${vars.theme.name}/${vars.theme.variant}";
    };
    home.file.kitty = {
      enable = true;
      source = ../configs/kitty/kitty.app.png;
      recursive = true;
      target = "${config.xdg.configHome}/kitty/kitty.app.png";
    };
  };
}
