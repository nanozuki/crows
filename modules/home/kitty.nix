{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.kitty;
  # choose themes by comman "kitten themes"
  themeFiles = {
    "rose-pine" = {
      light = "${pkgs.kitty-themes}/share/kitty-themes/themes/rose-pine-dawn.conf";
      dark = "${pkgs.kitty-themes}/share/kitty-themes/themes/rose-pine.conf";
    };
    "zenbones" = {
      light = "${pkgs.kitty-themes}/share/kitty-themes/themes/zenbones_light.conf";
      dark = "${pkgs.kitty-themes}/share/kitty-themes/themes/zenbones_dark.conf";
    };
  };
in
{
  options.crows.kitty = {
    enable = mkEnableOption "kitty";
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = pkgs.emptyDirectory;
      font.name = config.g.font.family;
      font.size = config.g.font.size;
      extraConfig = builtins.readFile ../../configs/kitty/kitty.conf;
      shellIntegration = {
        enableFishIntegration = true;
        mode = "no-cursor";
      };
    };
    home.file.kitty = {
      enable = true;
      source = ../../configs/kitty/kitty.app.png;
      recursive = true;
      target = "${config.xdg.configHome}/kitty/kitty.app.png";
    };
    home.file.kitty-light-theme = {
      enable = true;
      source = themeFiles.${config.g.theme.name}.light;
      target = "${config.xdg.configHome}/kitty/light-theme.auto.conf";
    };
    home.file.kitty-dark-theme = {
      enable = true;
      source = themeFiles.${config.g.theme.name}.dark;
      target = "${config.xdg.configHome}/kitty/dark-theme.auto.conf";
    };
  };
}
