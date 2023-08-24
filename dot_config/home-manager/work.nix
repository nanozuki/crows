{ pkgs, spkgs, ... }: {
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
    ]) ++ (with spkgs; [
      atlas
      go-swagger_0_25_0
      kratos
      kratos-protoc-gen-go-http
      kratos-protoc-gen-go-errors
    ]);
}
