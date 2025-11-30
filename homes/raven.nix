{ config, pkgs, ... }:
{
  config = {
    xdg.enable = true;
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;

    g.theme = {
      name = "zenbones";
      variant = "light";
    };

    home.packages = with pkgs; [
      codex
      ffmpeg
      gemini-cli
      zstd
    ];
    home.sessionPath = [
      "/opt/homebrew/bin"
    ];
    home.sessionVariables = {
      OS_CONFIG_NAME = "raven";
      HM_CONFIG_NAME = "raven";
    };

    crows.ghostty.enable = true;
    crows.git.enable = true;
    crows.kitty.enable = true;
    crows.languages.nix.enable = true;
    crows.neovim = {
      enable = true;
      hideCommandLine = true;
      useGlobalStatusline = true;
    };
    crows.one_password.enable = true;
    crows.shell.enable = true;
    crows.sops-secrets = {
      enable = true;
      name = "raven";
      sopsFile = ../secrets/raven.yaml;
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
    crows.wezterm.enable = true;
  };
}
