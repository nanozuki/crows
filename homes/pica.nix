{ pkgs, config, ... }:
{
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;

    g.theme = {
      name = "rose-pine";
      variant = "dawn";
    };

    home.packages = with pkgs; [
      awscli2
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
      zstd
    ];

    home.sessionPath = [
      "/opt/homebrew/bin"
    ];
    home.sessionVariables = {
      OS_CONFIG_NAME = "pica";
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
