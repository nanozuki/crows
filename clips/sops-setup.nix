# sops-setup
# 1. install rage and sops
# 2. use "id" to set defaultSopsKey and age.KeyFile
# @param id: sops identifier
# @return: home-manager config
id: { config, pkgs, ... }: {
  home.packages = [
    pkgs.rage
    pkgs.sops
  ];
  sops.defaultSopsFile = ../secrets/${id}.yaml;
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/${id}.txt";
}
