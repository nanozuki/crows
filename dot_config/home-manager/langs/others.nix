{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #ocaml
    # ocaml-ng.ocamlPackages_latest.ocaml
    # opam
    # ocaml-ng.ocamlPackages_latest.ocamlformat
    # ocaml-ng.ocamlPackages_latest.ocaml-lsp
    # ocaml-ng.ocamlPackages_latest.dune_3
    # ocaml-ng.ocamlPackages_latest.utop
    # terraform
    terraform
    terraform-ls
    # zig
    zig
    zls
  ];
}
