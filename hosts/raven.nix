{ pkgs, ... }:

{
  imports = [
    ../parts/mac_basic.nix
    ../parts/terminal.nix
  ];
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    home.packages = [
      pkgs.ffmpeg
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
        terraform = true;
        typescript_deno = true;
        typescript_node = true;
        zig = true;
      };
    };
  };
}
