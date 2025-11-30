{
  clips,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.crows.wezterm;
  themeSet = {
    "rose-pine/main" = "rose-pine";
    "rose-pine/dawn" = "rose-pine-dawn";
    "rose-pine/moon" = "rose-pine-moon";
    "nord/main" = "nord";
    "zenbones/light" = "zenbones";
    "zenbones/dark" = "zenbones_dark";
  };
  wezVars = {
    font = config.g.font;
    theme = themeSet."${config.g.theme.name}/${config.g.theme.variant}";
  };
in
{
  options.crows.wezterm = {
    enable = mkEnableOption "wezterm";
  };
  config = mkIf cfg.enable {
    home.file.wezterm = {
      enable = true;
      source = ../../configs/wezterm;
      recursive = true;
      target = "${config.xdg.configHome}/wezterm";
    };
    home.file.wezterm_vars = {
      enable = true;
      source = clips.mustache "vars.lua" ../../configs/wezterm/vars.lua.mustache wezVars;
      target = "${config.xdg.configHome}/wezterm/vars.lua";
    };
  };
}
