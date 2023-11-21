{ pkgs, sspkgs, stpkgs, config, ... }:
let
  sops-setup = import ../clips/sops-setup.nix;
in
{
  imports = [
    ../clips/common.nix
    (sops-setup "pica")
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
      stpkgs.awscli2
      mycli
      wire
      go-migrate
      sspkgs.atlas
      sspkgs.go-swagger_0_25_0
      sspkgs.kratos
      sspkgs.kratos-protoc-gen-go-http
      sspkgs.kratos-protoc-gen-go-errors
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
  };
}
