{ clips, config, lib, vars, ... }:
with lib;
let
  cfg = config.apps.wezterm;
  themeSet = {
    "rose-pine/main" = "rose-pine";
    "rose-pine/dawn" = "rose-pine-dawn";
    "rose-pine/moon" = "rose-pine-moon";
    "nord/main" = "nord";
    "edge/main" = "Edge Dark (base16)";
    "edge/aura" = "Edge Dark (base16)";
    "edge/neon" = "Edge Dark (base16)";
    "edge/light" = "Edge Light (base16)";
  };
  wezVars = {
    font = vars.font;
    theme = themeSet."${vars.theme.name}/${vars.theme.variant}";
  };
in
{
  options.apps.wezterm = { enable = mkEnableOption "wezterm"; };
  config = mkIf cfg.enable {
    home.file.wezterm = {
      enable = true;
      source = ../configs/wezterm;
      recursive = true;
      target = "${config.xdg.configHome}/wezterm";
    };
    home.file.wezterm_vars = {
      enable = true;
      source = clips.mustache "vars.lua" ../configs/wezterm/vars.lua.mustache wezVars;
      target = "${config.xdg.configHome}/wezterm/vars.lua";
    };
  };
}
