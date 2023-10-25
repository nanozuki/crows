{ pkgs, spkgs, ... }:

{
  imports = [
    ./parts/mac_basic.nix
    ./parts/terminal.nix
    ./parts/neovim.nix
    ./parts/languages.nix
    ./parts/working.private.nix # private settings
    ./parts/rime.nix
  ];
  config = {
    home.username = "crows";
    home.homeDirectory = "/Users/crows";

    home.stateVersion = "23.05"; # Please read the comment before changing.

    home.packages =
      (with pkgs; [
        # go repo's generate
        (python3.withPackages
          (ps: with ps; [
            pyyaml
          ]))
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

    home.file = { };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
