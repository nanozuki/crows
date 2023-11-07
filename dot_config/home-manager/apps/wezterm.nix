{ config, pkgs, vars, ... }: {
  home.file.wezterm = {
    enable = true;
    source = ../configs/wezterm;
    recursive = true;
    target = "${config.xdg.configHome}/wezterm";
  };
  home.file.wezterm_vars =
    let
      mustache = import ../tools/mustache.nix;
    in
    {
      enable = true;
      source = mustache pkgs "vars.lua" ../configs/wezterm/vars.lua.mustache vars;
      target = "${config.xdg.configHome}/wezterm/vars.lua";
    };
}
