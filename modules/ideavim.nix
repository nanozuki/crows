{ config, lib, ... }:
with lib;
let
  cfg = config.crows.ideavim;
in
{
  options.crows.ideavim = {
    enable = mkEnableOption "ideavim";
  };
  config = mkIf cfg.enable {
    home.file.ideavim = {
      enable = true;
      source = ../configs/ideavim/ideavimrc;
      target = "${config.xdg.configHome}/ideavim/ideavimrc";
    };
  };
}
