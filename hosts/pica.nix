{ pkgs, spkgs, config, ... }:

{
  imports = [
    ../parts/terminal.nix
    ../parts/rime.nix
    ../parts/secrets.nix
  ];
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    home.packages = (with pkgs; [
      # go repo's generate
      (python3.withPackages (ps: [ ps.pyyaml ]))
      # grpc
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
      protoc-gen-validate
      gnostic # protoc-gen-openapi
      awscli2
      mycli
      wire
      go-migrate
    ]) ++ (with spkgs; [
      atlas
      go-swagger_0_25_0
      kratos
      kratos-protoc-gen-go-http
      kratos-protoc-gen-go-errors
    ]);

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
    sops.defaultSopsFile = ../secrets/pica.yaml;
    sops.age.keyFile = "${config.xdg.configHome}/sops/age/pica.txt";
    sops.secrets.go_private = {
      path = "${config.xdg.configHome}/fish/after/go_private.fish";
    };
  };
}
