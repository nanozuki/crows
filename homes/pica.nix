{ pkgs, config, ... }:
{
  config = {
    xdg.enable = true;
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;

    g.theme = {
      name = "rose-pine";
      variant = "dawn";
    };

    home.packages = with pkgs; [
      buf
      codex
      k9s
      kustomize
      libxml2
      gemini-cli
      gnumake
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.kubectl
      ])
      pipenv
      pkg-config
      go-protobuf
      protoc-gen-go-grpc
      protobuf
      yq-go
      zstd
    ];

    home.sessionPath = [
      "/opt/homebrew/bin"
      "${config.home.homeDirectory}/.rd/bin" # for rancher desktop
    ];
    home.sessionVariables = {
      OS_CONFIG_NAME = "pica";
      HM_CONFIG_NAME = "pica";
    };

    crows.ghostty.enable = true;
    crows.git.enable = true;
    crows.kitty.enable = true;
    crows.languages = {
      go.enable = true;
      nix.enable = true;
      typescript_node.enable = true;
    };
    crows.neovim = {
      enable = true;
      hideCommandLine = true;
      useGlobalStatusline = true;
      useGofumpt = false;
    };
    crows.one_password.enable = true;
    crows.shell.enable = true;
    crows.sops-secrets = {
      enable = true;
      name = "pica";
      sopsFile = ../secrets/pica.yaml;
      secrets = {
        git_config_local = {
          path = "${config.xdg.configHome}/git/config_local";
        };
        git_config_a = {
          path = "${config.xdg.configHome}/git/config_a";
        };
      };
    };
    crows.wezterm.enable = true;
  };
}
