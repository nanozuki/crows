# Global settings for languages and related tools
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.languages;
  dataAndMarkup = {
    home.packages = with pkgs; [
      vscode-langservers-extracted # include {html,css,json,eslint}-language-server
      nodePackages.yaml-language-server
      #  formatter with many language supportted
      nodePackages.prettier
    ];
  };
  go = {
    home.packages = with pkgs; [
      delve
      gofumpt # formatter
      golangci-lint # linter
      gomodifytags
      gopls # language server
      gotests
      gotestsum
      gotools
      iferr
      impl
      wire
    ];
    programs.go = {
      enable = true;
      goPath = ".local/share/go";
    };
    home.sessionVariables = {
      GOROOT = "${pkgs.go}/share/go";
    };
    home.sessionPath = [
      "$GOPATH/bin"
    ];
  };
  lua = {
    home.packages = with pkgs; [ lua-language-server stylua ];
  };
  nix = {
    home.packages = with pkgs; [ nil nixpkgs-fmt ];
  };
  ocaml = {
    home.packages = with pkgs; [
      ocamlPackages.ocaml
      ocamlPackages.ocamlformat
      ocamlPackages.ocaml-lsp
    ];
  };
  rust = {
    home.packages = with pkgs; [
      (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
      rust-analyzer
    ];
    home.sessionVariables = { CARGO_HOME = "${config.xdg.dataHome}/cargo"; };
    home.sessionPath = [ "${config.xdg.dataHome}/cargo/bin" ];
  };
  svelte = {
    home.packages = with pkgs; [
      nodePackages.svelte-language-server
      nodePackages.svelte-check
    ];
  };
  typescript_deno = {
    home.packages = [ pkgs.deno ];
  };
  typescript_node = {
    home.packages = with pkgs; [
      ## runtime and package manager
      nodePackages.nodejs
      nodePackages.pnpm
      # language server
      nodePackages.typescript
      nodePackages."@tailwindcss/language-server"
      # linter
      nodePackages.eslint
      nodePackages.eslint_d
    ];
    home.sessionVariables = {
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    };
    home.file.npmrc = {
      enable = true;
      text = ''
        prefix=${config.xdg.dataHome}/npm
        cache=${config.xdg.cacheHome}/npm
        init-module=${config.xdg.configHome}/npm/config/npm-init.js
      '';
      target = "${config.xdg.configHome}/npm/npmrc";
    };
    home.sessionPath = [
      "${config.xdg.dataHome}/npm/bin"
    ];
  };
  typst = mkIf cfg.language.typst {
    home.packages = with pkgs; [ typst typst-lsp ];
  };
  vim = {
    home.packages = with pkgs; [ nodePackages.vim-language-server ];
  };
  zig = mkIf cfg.language.zig {
    home.packages = with pkgs; [ zig zls ];
  };
in
{
  options.languages.dataAndMarkup = { enable = mkEnableOption "Data and Markup Languages"; };
  options.languages.go = { enable = mkEnableOption "Go"; };
  options.languages.lua = { enable = mkEnableOption "Lua"; };
  options.languages.nix = { enable = mkEnableOption "Nix"; };
  options.languages.ocaml = { enable = mkEnableOption "OCaml"; };
  options.languages.rust = { enable = mkEnableOption "Rust"; };
  options.languages.svelte = { enable = mkEnableOption "Svelte"; };
  options.languages.terraform = { enable = mkEnableOption "Terraform"; };
  options.languages.typescript_deno = { enable = mkEnableOption "Typescript on Deno"; };
  options.languages.typescript_node = { enable = mkEnableOption "Typescript on Node.js"; };
  options.languages.typst = { enable = mkEnableOption "Typst"; };
  options.languages.vim = { enable = mkEnableOption "Vim"; };
  options.languages.zig = { enable = mkEnableOption "Zig"; };

  config = mkMerge [
    (mkIf cfg.dataAndMarkup.enable dataAndMarkup)
    (mkIf cfg.go.enable go)
    (mkIf cfg.lua.enable lua)
    (mkIf cfg.nix.enable nix)
    (mkIf cfg.ocaml.enable ocaml)
    (mkIf cfg.rust.enable rust)
    (mkIf cfg.svelte.enable svelte)
    (mkIf cfg.typescript_deno.enable typescript_deno)
    (mkIf cfg.typescript_node.enable typescript_node)
    (mkIf cfg.typst.enable typst)
    (mkIf cfg.vim.enable vim)
    (mkIf cfg.zig.enable zig)
  ];
}
