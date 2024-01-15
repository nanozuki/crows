{ clips, pkgs, config, ... }:
{
  imports = [
    clips.common
    clips.sops-setup
  ];
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      zstd
      # go repo's generate
      (python3.withPackages (ps: [ ps.pyyaml ]))
      # grpc and protobuf
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
      protoc-gen-validate
      gnostic # protoc-gen-openapi
      awscli2
      mycli
      wire
      go-migrate
      atlas
      stra.go-swagger_0_25_0
      stra.kratos
      stra.kratos-protoc-gen-go-http
      stra.kratos-protoc-gen-go-errors
    ];

    home.sessionPath = [
      "/opt/homebrew/bin"
    ];
    home.sessionVariables = {
      HM_CONFIG_NAME = "pica";
    };
    apps.neovim = {
      enable = true;
      useNoice = true;
      useGlobalStatusline = true;
      language = {
        go = true;
        ocaml = false;
        rust = true;
        svelte = true;
        terraform = true;
        typescript_deno = true;
        typescript_node = true;
        zig = true;
      };
    };
    apps.rime.enable = true;
    sops.secrets.go_private = {
      path = "${config.xdg.configHome}/fish/after/go_private.fish";
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
    sops.secrets.netrc = {
      path = "${config.home.homeDirectory}/.netrc";
    };
  };
}
