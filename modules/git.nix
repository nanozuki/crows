{ config, lib, pkgs, system, ... }:
with lib;
let cfg = config.apps.git;
in
{
  options.apps.git = { enable = mkEnableOption "git"; };
  config = mkIf cfg.enable {
    home.packages = if (hasSuffix "darwin" system) then [ pkgs.git ] else [ ];
    home.file.git = {
      enable = true;
      source = ../configs/git;
      target = "${config.xdg.configHome}/git";
      recursive = true;
    };
  };
}
