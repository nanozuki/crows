{ config, lib, ... }:
with lib;
let cfg = config.apps.ideavim;
in
{
  options.apps.ideavim = { enable = mkEnableOption "ideavim"; };
  config = mkIf cfg.enable {
    home.file.ideavim = {
      enable = true;
      source = ../configs/ideavim/ideavimrc;
      target = "${config.xdg.configHome}/ideavim/ideavimrc";
    };
  };
}
