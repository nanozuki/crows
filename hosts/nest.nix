{ config, pkgs, vars, ... }:
let
  mustache = import ../clips/mustache.nix;
  sops-setup = import ../clips/sops-setup.nix;
in
{
  imports = [
    ../clips/common.nix
    (sops-setup "nest")
  ];
  config = {
    home.username = "crows";
    home.homeDirectory = "/home/crows";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    home.sessionVariables = {
      HM_CONFIG_NAME = "nest";
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
    apps.rime.enable = true;
    apps.sway.enable = true;
    apps.waybar.enable = true;

    home.file.fontConfig = {
      enable = true;
      source = mustache pkgs "font.conf" ../configs/fontconfig/fonts.conf.mustache vars;
      target = "${config.xdg.configHome}/fontconfig/fonts.conf";
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