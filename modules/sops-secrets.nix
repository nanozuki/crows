{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.sops-secrets;
in
{
  options.crows.sops-secrets = {
    enable = mkEnableOption "secrets";
    name = mkOption {
      type = types.str;
      description = "name of the secrets";
    };
    secrets = mkOption {
      type = types.anything;
      description = "list of secrets' definitions";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.rage
      pkgs.sops
    ];
    sops.defaultSopsFile = ../secrets/${cfg.name}.yaml;
    sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    sops.secrets = cfg.secrets;
  };
}
