{ config, pkgs, vars, ... }:
{
  programs.kitty = {
    enable = true;
    package = pkgs.fish; # just to ignore package installation
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
}
