{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.apps.vimr;
in
{
  options.apps.vimr = {
    enable = mkEnableOption "VimR";
  };
  config = mkIf cfg.enable {
    homebrew.casks = [ "vimr" ];
    environment.systemPackages = with pkgs; [
      nodePackages.neovim
      nodePackages.nodejs
    ];
  };
}
