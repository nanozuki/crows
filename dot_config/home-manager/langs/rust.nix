{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustc
    cargo
    rust-analyzer
    rustfmt
  ];
}
