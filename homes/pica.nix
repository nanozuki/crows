{ pkgs, config, ... }:
{
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      zstd
      awscli2
    ];

    home.sessionPath = [
      "/opt/homebrew/bin"
    ];
    home.sessionVariables = {
      HM_CONFIG_NAME = "pica";
    };
    apps.neovim = {
      enable = true;
      hideCommandLine = true;
      useGlobalStatusline = true;
    };
    apps.sops-secrets = {
      enable = true;
      name = "pica";
      secrets = {
        go_private = {
          path = "${config.xdg.configHome}/fish/after/go_private.fish";
        };
        git_config_local = {
          path = "${config.xdg.configHome}/git/config_local";
        };
        git_config_a = {
          path = "${config.xdg.configHome}/git/config_a";
        };
        git_config_b = {
          path = "${config.xdg.configHome}/git/config_b";
        };
        netrc = {
          path = "${config.home.homeDirectory}/.netrc";
        };
      };
    };
    apps.rime.enable = true;
    languages.go.enable = true;
    languages.nix.enable = true;
  };
}
