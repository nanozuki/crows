{ config, lib, pkgs, vars, ... }:
with lib;
let
  cfg = config.apps.neovim;
  basic = {
    home.packages = with pkgs; [
      # tools
      ripgrep
      fzf
      # config and markup languages 
      ## nix
      nil
      nixpkgs-fmt
      ## lua
      lua-language-server
      stylua
      ## vim 
      nodePackages.vim-language-server
      ## json, yaml
      vscode-langservers-extracted # include {html,css,json,eslint}-language-server
      nodePackages.yaml-language-server
      #  formatter with many language supportted
      nodePackages.prettier
    ];
    programs.neovim = {
      enable = true;
      withPython3 = true;
      withNodeJs = true;
      # dependencies for CopilotChat.nvim
      extraPython3Packages = (pyPkgs: with pyPkgs; [ python-dotenv requests prompt-toolkit tiktoken ]);
    };
    programs.fish.shellAbbrs = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
    home.sessionVariables = {
      EDITOR = "nvim";
    };
    home.file.neovim = {
      enable = true;
      source = ../configs/nvim;
      target = "${config.xdg.configHome}/nvim";
      recursive = true;
    };
    home.file.neovim_custom = {
      enable = true;
      text = builtins.toJSON {
        theme = {
          name = vars.theme.name;
          variant = vars.theme.variant;
        };
        languages = { vim = true; json = true; yaml = true; nix = true; } // cfg.language;
        use_global_statusline = cfg.useGlobalStatusline;
        use_noice = cfg.useNoice;
      };
      target = "${config.xdg.configHome}/nvim/custom.json";
    };
  };
  language_go = mkIf cfg.language.go {
    home.packages = with pkgs; [
      gopls # language server
      golangci-lint # linter
      gofumpt # formatter
      gomodifytags
      gotests
      gotestsum
      iferr
      impl
      delve
      wire
    ];
    programs.go = {
      enable = true;
      goPath = ".local/share/go";
    };
    home.sessionPath = [
      "$GOPATH/bin"
    ];
  };
  language_ocaml = mkIf cfg.language.ocaml {
    home.packages = with pkgs; [
      ocaml-ng.ocamlPackages_latest.ocaml
      opam
      ocaml-ng.ocamlPackages_latest.ocamlformat
      ocaml-ng.ocamlPackages_latest.ocaml-lsp
      ocaml-ng.ocamlPackages_latest.dune_3
      ocaml-ng.ocamlPackages_latest.utop
    ];
  };
  language_rust = mkIf cfg.language.rust {
    home.packages = with pkgs; [
      (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
      rust-analyzer
    ];
    home.sessionVariables = { CARGO_HOME = "${config.xdg.dataHome}/cargo"; };
    home.sessionPath = [ "${config.xdg.dataHome}/cargo/bin" ];
  };
  language_svelte = mkIf cfg.language.svelte {
    home.packages = with pkgs; [
      nodePackages.svelte-language-server
      nodePackages.svelte-check
    ];
  };
  language_terraform = mkIf cfg.language.terraform {
    home.packages = with pkgs; [
      terraform
      terraform-ls
    ];
  };
  language_typescript_deno = mkIf cfg.language.typescript_deno {
    home.packages = [ pkgs.deno ];
  };
  language_typescript_node = mkIf cfg.language.typescript_node {
    home.packages = with pkgs; [
      ## frontend languages
      nodePackages.nodejs
      nodePackages.pnpm
      # language server
      nodePackages.typescript
      nodePackages."@tailwindcss/language-server"
      # linter
      nodePackages.eslint
      nodePackages.eslint_d
      # tools
      nodePackages.npm-check-updates
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
  language_typst = mkIf cfg.language.typst {
    home.packages = with pkgs; [
      typst
      typst-lsp
    ];
  };
  language_zig = mkIf cfg.language.zig {
    home.packages = with pkgs; [
      zig
      zls
    ];
  };
in
{
  options.apps.neovim = {
    enable = mkEnableOption "Neovim";
    useNoice = mkEnableOption "Noice";
    useGlobalStatusline = mkEnableOption "Global statusline";
    language = mkOption {
      description = "Enable language support";
      type = types.submodule {
        options = {
          go = mkEnableOption "Go";
          ocaml = mkEnableOption "OCaml";
          rust = mkEnableOption "Rust";
          svelte = mkEnableOption "Svelte";
          terraform = mkEnableOption "Terraform";
          typescript_deno = mkEnableOption "Typescript on Deno";
          typescript_node = mkEnableOption "Typescript on Node.js";
          typst = mkEnableOption "Typst";
          zig = mkEnableOption "Zig";
        };
      };
    };
  };

  config =
    mkIf cfg.enable (mkMerge [
      basic
      language_go
      language_ocaml
      language_rust
      language_svelte
      language_terraform
      language_typescript_deno
      language_typescript_node
      language_typst
      language_zig
    ]);
}
