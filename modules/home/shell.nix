# configs for shell application and related tools
{
  config,
  lib,
  pkgs,
  system,
  ...
}:
let
  cfg = config.crows.shell;
  startshipPresetsPath = "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml";
  startshipPresets = builtins.fromTOML (builtins.readFile startshipPresetsPath);
  publicFishFunctions = {
    gitget = ../../configs/fish/functions/gitget.fish;
    import_gpg_keys = ../../configs/fish/functions/import_gpg_keys.fish;
    update-env = ../../configs/fish/functions/update-env.fish;
    check-true-color = ../../configs/fish/functions/check-true-color.fish;
    sha-rename = ../../configs/fish/functions/sha-rename.fish;
  }
  // lib.optionalAttrs (system == "x86_64-linux") {
    reload-bluetooth = ../../configs/fish/functions/reload-bluetooth.fish;
  };
  fishFunctions = publicFishFunctions // cfg.fishFunctions;
  fishFunctionFiles = lib.mapAttrs' (
    name: source:
    lib.nameValuePair "fish_function_${name}" {
      enable = true;
      inherit source;
      target = "${config.xdg.configHome}/fish/functions/${name}.fish";
    }
  ) fishFunctions;
in
{
  options.crows.shell = {
    enable = lib.mkEnableOption "shell and related tools";
    fishFunctions = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = "Extra fish functions keyed by function name.";
    };
  };
  config = lib.mkIf cfg.enable {
    xdg.enable = true;

    home = {
      file = {
        editorconfig = {
          enable = true;
          source = ../../configs/editorconfig/editorconfig;
          target = "${config.home.homeDirectory}/.editorconfig";
        };
      } // fishFunctionFiles;
      packages = with pkgs; [
        babelfish
        tokei
        gron
      ];
      shell.enableShellIntegration = true;
      sessionPath = [
        "$HOME/.local/bin"
      ];
    };

    programs = {
      atuin = {
        enable = true;
        settings = {
          filter_mode_shell_up_key_binding = "directory";
          inline_height = 20;
          invert = true;
        };
      };
      bat.enable = true;
      btop = {
        enable = true;
        settings.color_theme = "TTY";
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      eza = {
        enable = true;
        colors = "auto";
        git = true;
        icons = "auto";
      };
      fd.enable = true;
      fish = {
        enable = true;
        shellAbbrs = {
          psg = "ps aux | grep";
          wget = "curl -O";
          e = "eza";
          el = "eza -l";
          ea = "eza -a";
          eal = "eza -al";
          ela = "eza -al";
          et = "eza -T";
        };
        interactiveShellInit = ''
          # kubectl
          set -gx KUBECONFIG "$HOME/.config/cluster/config"

          # source after snippets
          for file in $HOME/.config/fish/after/*.fish
              source $file
          end
        '';
        plugins = [
          {
            name = "z";
            src = pkgs.fishPlugins.z.src;
          }
          {
            name = "fzf-fish";
            src = pkgs.fishPlugins.fzf-fish.src;
          }
        ];
      };
      fzf.enable = true;
      jq.enable = true;
      ripgrep.enable = true;
      starship = {
        enable = true;
        enableFishIntegration = true;
        settings = lib.mkMerge [
          startshipPresets
          {
            character = {
              success_symbol = "[»](bold purple)";
              error_symbol = "[»](bold red)";
            };
            directory = {
              truncation_length = 10;
              truncate_to_repo = false;
              fish_style_pwd_dir_length = 1;
            };
            git_metrics = {
              added_style = "green";
              deleted_style = "red";
              format = "([+$added]($added_style))([-$deleted]($deleted_style)) ";
              disabled = false;
            };
            status = {
              disabled = false;
            };
            lua = {
              disabled = true;
            };
            aws = {
              disabled = true;
            };
            gcloud = {
              disabled = true;
            };
          }
        ];
      };
      tealdeer = {
        enable = true;
        settings = {
          updates = {
            auto_update = true;
            auto_update_interval_hours = 24;
          };
        };
      };
    };
  };
}
