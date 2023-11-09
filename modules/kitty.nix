{ config, lib, pkgs, vars, ... }:
with lib;
let cfg = config.apps.kitty;
in
{
  options.apps.kitty = { enable = mkEnableOption "kitty"; };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = pkgs.hello; # ignore package
      font.name = vars.fontFamily;
      font.size = vars.fontSize;
      extraConfig = builtins.readFile ../configs/kitty/kitty.conf;
      shellIntegration.enableFishIntegration = true;
      theme = "Rosé Pine Dawn";
    };
    home.file.kitty = {
      enable = true;
      source = ../configs/kitty/kitty.app.png;
      recursive = true;
      target = "${config.xdg.configHome}/kitty/kitty.app.png";
    };
  };
}
