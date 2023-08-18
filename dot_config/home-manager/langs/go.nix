{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gopls # language server
    golangci-lint # linter
    gotools # goimports, formatter
    gomodifytags
    gotests
    gotestsum
    iferr
    impl
    delve
    go-global-update
  ];

  home.sessionPath = [
    "$GOPATH/bin"
  ];

  programs.go = {
    enable = true;
    goPath = ".local/share/go";
    goPrivate = [  ];
  };
}
