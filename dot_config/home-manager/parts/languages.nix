{ pkgs, config ... }:
{
  home.packages = with pkgs; [

    ## golang
    gopls # language server
    golangci-lint # linter
    gotools # goimports, formatter
    gomodifytags
    gotests
    gotestsum
    iferr
    impl
    delve

    ## frontend languages
    nodePackages.nodejs
    nodePackages.pnpm
    # language server
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages."@tailwindcss/language-server"
    # linter
    nodePackages.eslint
    nodePackages.eslint_d
    # formatter
    nodePackages.prettier
    # deno runtime
    deno

    ## ocaml
    # ocaml-ng.ocamlPackages_latest.ocaml
    # opam
    # ocaml-ng.ocamlPackages_latest.ocamlformat
    # ocaml-ng.ocamlPackages_latest.ocaml-lsp
    # ocaml-ng.ocamlPackages_latest.dune_3
    # ocaml-ng.ocamlPackages_latest.utop

    ## rust
    rustc
    cargo
    rust-analyzer
    rustfmt

    ## terraform
    terraform
    terraform-ls

    ## zig
    zig
    zls

  ];

  home.sessionVariables = {
    ## frontend languages
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    ## rust
    CARGO_HOME = "${xdg.dataHome}/cargo"
  };

  home.sessionPath = [
    ## golang
    "$GOPATH/bin"
    ## frontend languages
    "${config.xdg.dataHome}/npm/bin"
    ## rust
    "${xdg.dataHome}/cargo/bin"
  ];

  programs.go = {
    enable = true;
    goPath = ".local/share/go";
  };
}