{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.apps.vimr;
in
{
  options.apps.vimr = {
    enable = mkEnableOption "VimR";
    snapshot = mkEnableOption "Use snapshot version";
  };
  config = mkIf cfg.enable {
    homebrew.casks = if cfg.snapshot then [ ] else [ "vimr" ];
    # check neovim.nix in nanozuki/crows to get dependencies
    environment.systemPackages = with pkgs; [
      neovim-node-client
      nodePackages.nodejs
      luajitPackages.tiktoken_core
    ];
  };
}
