{ pkgs, ... }: {
  home.packages = [
    pkgs.rage
    pkgs.sops
  ];
}
