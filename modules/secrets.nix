{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.apps.secrets;
in
{
  options.apps.secrets = {
    enable = mkEnableOption "secrets";
    name = mkOption {
      type = types.str;
      description = "name of the secrets";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.rage
      pkgs.sops
    ];
    sops.defaultSopsFile = ../secrets/${cfg.name}.yaml;
    sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };
}
