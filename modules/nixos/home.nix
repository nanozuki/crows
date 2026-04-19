{ inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.sops-nix.homeManagerModule
      ../home
    ];
    extraSpecialArgs = {
      system = pkgs.stdenv.hostPlatform.system;
      clips = import ../../clips pkgs pkgs.stdenv.hostPlatform.system;
    };
  };
}
