{ config, lib, pkgs, vars, ... }:
with lib;
let
  cfg = config.apps.wezterm;
  mustache = import ../clips/mustache.nix;
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
      source = mustache pkgs "vars.lua" ../configs/wezterm/vars.lua.mustache vars;
      target = "${config.xdg.configHome}/wezterm/vars.lua";
    };
  };
}
