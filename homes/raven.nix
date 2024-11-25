{ config, pkgs, ... }:
{
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";
    home.stateVersion = "24.11";
    programs.home-manager.enable = true;

    g.theme = {
      name = "zenbones";
      variant = "light";
    };

    home.packages = with pkgs; [
      ffmpeg
      zstd
    ];
    home.sessionPath = [
      "/opt/homebrew/bin"
    ];
    home.sessionVariables = {
      OS_CONFIG_NAME = "raven";
      HM_CONFIG_NAME = "raven";
    };
    apps.neovim = {
      enable = true;
      hideCommandLine = true;
      useGlobalStatusline = true;
    };
    apps.sops-secrets = {
      enable = true;
      name = "raven";
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
