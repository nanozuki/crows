{ ... }:
{
  imports = [
    ../parts/terminal.nix
    ../parts/rime.nix
    ../apps/sway.nix
    ../apps/waybar.nix
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
  };
}
