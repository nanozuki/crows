{ pkgs, ... }: {
  home.packages = with pkgs; [
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
  ];
}
# escaped packages:
# - go-swagger 0.25.0
# - github.com/go-kratos/kratos/cmd/protoc-gen-go-http/v2@latest
# - github.com/go-kratos/kratos/cmd/protoc-gen-go-errors/v2@latest
# - https://github.com/ariga/atlas
# - wire@0.5
