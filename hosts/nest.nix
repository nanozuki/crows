{ clips, config, vars, ... }:
{
  imports = [
    clips.common
  ];
  config = {
    home.username = "crows";
    home.homeDirectory = "/home/crows";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    home.sessionVariables = {
      HM_CONFIG_NAME = "nest";
    };
    home.file.fontConfig = {
      enable = true;
      source = clips.mustache "font.conf" ../configs/fontconfig/fonts.conf.mustache vars;
      target = "${config.xdg.configHome}/fontconfig/fonts.conf";
    };

    apps.neovim = {
      enable = true;
      hideCommandLine = true;
      useGlobalStatusline = true;
    };
    apps.rime.enable = true;
    apps.sway.enable = true;
    apps.waybar.enable = true;
    apps.sops-secrets = {
      enable = true;
      name = "nest";
      secrets = {
        git_config_local = {
          path = "${config.xdg.configHome}/git/config_local";
        };
        git_config_a = {
          path = "${config.xdg.configHome}/git/config_a";
        };
        git_config_b = {
          path = "${config.xdg.configHome}/git/config_b";
        };
      };
    };
    languages.nix.enable = true;
  };
}
