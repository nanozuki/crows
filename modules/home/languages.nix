# Global settings for languages and related tools
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.languages;
  dataAndMarkup = {
    home.packages = with pkgs; [
      vscode-langservers-extracted # include {html,css,json,eslint}-language-server
      nodePackages.yaml-language-server
      #  formatter with many language supportted
      nodePackages.prettier
    ];
  };
  gleam = {
    home.packages = [
      pkgs.gleam
      pkgs.erlang
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
      env = {
        GOPATH = "${config.xdg.dataHome}/go";
      };
    };
    home.sessionVariables = {
      GOROOT = "${pkgs.go}/share/go";
    };
    home.sessionPath = [
      "${config.xdg.dataHome}/go/bin"
    ];
  };
  lua = {
    home.packages = with pkgs; [
      lua-language-server
      stylua
    ];
  };
  nix = {
    home.packages = with pkgs; [
      nil
      nixfmt
    ];
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
    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
    };
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
      vtsls
      # linter
      nodePackages.eslint
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
    home.packages = with pkgs; [
      typst
      typst-lsp
    ];
  };
  vim = {
    home.packages = with pkgs; [ nodePackages.vim-language-server ];
  };
  zig = mkIf cfg.language.zig {
    home.packages = with pkgs; [
      zig
      zls
    ];
  };
in
{
  options.crows.languages.dataAndMarkup = {
    enable = mkEnableOption "Data and Markup Languages";
  };
  options.crows.languages.gleam = {
    enable = mkEnableOption "Gleam";
  };
  options.crows.languages.go = {
    enable = mkEnableOption "Go";
  };
  options.crows.languages.lua = {
    enable = mkEnableOption "Lua";
  };
  options.crows.languages.nix = {
    enable = mkEnableOption "Nix";
  };
  options.crows.languages.ocaml = {
    enable = mkEnableOption "OCaml";
  };
  options.crows.languages.rust = {
    enable = mkEnableOption "Rust";
  };
  options.crows.languages.svelte = {
    enable = mkEnableOption "Svelte";
  };
  options.crows.languages.terraform = {
    enable = mkEnableOption "Terraform";
  };
  options.crows.languages.typescript_deno = {
    enable = mkEnableOption "Typescript on Deno";
  };
  options.crows.languages.typescript_node = {
    enable = mkEnableOption "Typescript on Node.js";
  };
  options.crows.languages.typst = {
    enable = mkEnableOption "Typst";
  };
  options.crows.languages.vim = {
    enable = mkEnableOption "Vim";
  };
  options.crows.languages.zig = {
    enable = mkEnableOption "Zig";
  };

  config = mkMerge [
    (mkIf cfg.dataAndMarkup.enable dataAndMarkup)
    (mkIf cfg.gleam.enable gleam)
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
