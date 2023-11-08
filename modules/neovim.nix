{ config, lib, pkgs, ... }:
with lib;
{
  options.apps.neovim = {
    enable = mkEnableOption "Neovim";
    useNoice = mkEnableOption "Noice";
    useGlobalStatusline = mkEnableOption "Global statusline";
    language = mkOption {
      # default enable lua, vim, yaml, json, nix
      type = types.submodule {
        options = {
          deno = mkEnableOption "Deno";
          go = mkEnableOption "Golang";
          ocaml = mkEnableOption "OCaml";
          rust = mkEnableOption "Rust";
          terraform = mkEnableOption "Terraform";
          web = mkEnableOption "Web";
          zig = mkEnableOption "Zig";
        };
      };
    };
  };

  config =
    let
      cfg = config.apps.neovim;
    in
    mkIf cfg.enable mkMerge [
      # default
      {
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
          nodePackages.prettier
          # other editors
          helix # TODO: should this be here?
          # doc generation
          pandoc
        ];
        programs.neovim = {
          enable = true;
          withPython3 = true;
          withNodeJs = true;
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
              name = "rose_pine";
              variant = "dawn";
            };
            languages = {
              vim = true;
              yaml = true;
              json = true;
              go = cfg.language.go;
              rust = cfg.language.rust;
              web = cfg.language.web;
              deno = cfg.language.deno;
              ocaml = cfg.language.ocaml;
              terraform = cfg.language.terraform;
              zig = cfg.language.zig;
              nix = true;
            };
            use_global_statusline = cfg.useGlobalStatusline;
            use_noice = cfg.useNoice;
          };
          target = "${config.xdg.configHome}/nvim/custom.json";
        };
      }
      (mkIf cfg.languages.deno {
        home.packages = with pkgs;
          [ deno ];
      })
      (mkIf cfg.languages.go {
        home.packages = with pkgs; [
          gopls # language server
          golangci-lint # linter
          gotools # goimports, formatter
          gofumpt
          gomodifytags
          gotests
          gotestsum
          iferr
          impl
          delve
          go-mockery
        ];
        programs.go = {
          enable = true;
          goPath = ".local/share/go";
        };
        home.sessionPath = [
          "$GOPATH/bin"
        ];
      })
      (mkIf cfg.languages.ocaml {
        home.packages = with pkgs; [
          ocaml-ng.ocamlPackages_latest.ocaml
          opam
          ocaml-ng.ocamlPackages_latest.ocamlformat
          ocaml-ng.ocamlPackages_latest.ocaml-lsp
          ocaml-ng.ocamlPackages_latest.dune_3
          ocaml-ng.ocamlPackages_latest.utop
        ];
      })
      (mkIf cfg.languages.rust {
        home.programs = with pkgs; [
          (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
          rust-analyzer
        ];
        home.sessionVariables = { CARGO_HOME = "${config.xdg.dataHome}/cargo"; };
        home.sessionPath = [ "${config.xdg.dataHome}/cargo/bin" ];
      })
      (mkIf cfg.languages.terraform {
        home.packages = with pkgs; [
          terraform
          terraform-ls
        ];
      })
      (mkIf cfg.languages.web {
        home.programs = with pkgs; [
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
      })
      (mkIf cfg.languages.zig {
        home.packages = with pkgs; [
          zig
          zls
        ];
      })
    ];
}
