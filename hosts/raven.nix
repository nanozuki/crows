{ config, pkgs, ... }:

let
  sops-setup = import ../clips/sops-setup.nix;
in
{
  imports = [
    ../clips/common.nix
    (sops-setup "raven")
  ];
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      ffmpeg
      zstd
    ];
    home.sessionPath = [
      "/opt/homebrew/bin"
    ];
    home.sessionVariables = {
      HM_CONFIG_NAME = "raven";
    };
    apps.neovim = {
      enable = true;
      useNoice = true;
      useGlobalStatusline = true;
      language = {
        go = true;
        ocaml = false;
        rust = true;
        svelte = true;
        terraform = true;
        typescript_deno = true;
        typescript_node = true;
        zig = true;
      };
    };

    sops.secrets.git_config_local = {
      path = "${config.xdg.configHome}/git/config_local";
    };
    sops.secrets.git_config_a = {
      path = "${config.xdg.configHome}/git/config_a";
    };
    sops.secrets.git_config_b = {
      path = "${config.xdg.configHome}/git/config_b";
    };
  };
}
