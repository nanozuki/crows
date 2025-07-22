{ pkgs, config, ... }:
{
  config = {
    home.username = "wtang";
    home.homeDirectory = "/Users/wtang";
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;

    g.theme = {
      name = "rose-pine";
      variant = "dawn";
    };

    home.packages = with pkgs; [
      git
      jq
      k9s
      kustomize
      libxml2
      gemini-cli
      gnumake
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
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
    apps.neovim = {
      enable = true;
      hideCommandLine = true;
      useGlobalStatusline = true;
    };
    apps.sops-secrets = {
      enable = true;
      name = "pica";
      secrets = {
        git_config_local = {
          path = "${config.xdg.configHome}/git/config_local";
        };
        git_config_a = {
          path = "${config.xdg.configHome}/git/config_a";
        };
      };
    };
    apps.rime.enable = true;
    languages.go.enable = true;
    languages.nix.enable = true;
    languages.typescript_node.enable = true;
  };
}
