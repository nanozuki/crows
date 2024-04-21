{ pkgs, lib, system, ... }:
{
  apps.bat.enable = true;
  apps.git.enable = true;
  apps.gpg.enable = true;
  apps.ideavim.enable = true;
  apps.kitty.enable = true;
  apps.starship.enable = true;
  apps.tealdeer.enable = true;
  apps.wezterm.enable = true;

  xdg.enable = true;
  home.packages = with pkgs; [
    babelfish
    eza
    btop
    tokei
    fd
    jq
    gron
    just
    helix
    lazygit
    ngrok
    k9s
  ];
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  programs.fish = {
    enable = true;
    shellAbbrs = {
      psg = "ps aux | grep";
      wget = "curl -O";
      e = "eza --icons always";
      el = "eza --icons -l";
      ea = "eza --icons -a";
      eal = "eza --icons -al";
      ela = "eza --icons -al";
      et = "eza --icons -T";
      hm = "home-manager --flake ~/.config/home-manager#$HM_CONFIG_NAME";
    };
    functions = {
      gitget = { body = builtins.readFile ../configs/fish/functions/gitget.fish; };
      import_gpg_keys = { body = builtins.readFile ../configs/fish/functions/import_gpg_keys.fish; };
      update-env = { body = builtins.readFile ../configs/fish/functions/update-env.fish; };
      check-true-color = { body = builtins.readFile ../configs/fish/functions/check-true-color.fish; };
    } // lib.optionalAttrs (system == "x86_64-linux") {
      reload-bluetooth = { body = builtins.readFile ../configs/fish/functions/reload-bluetooth.fish; };
    };
    interactiveShellInit = ''
      # kubectl
      set -gx KUBECONFIG "$HOME/.config/cluster/config"

      # history across fishes
      function save_history --on-event fish_preexec
          history --save
          history --merge
      end
      alias hr 'history --merge' # read and merge history from disk
      bind \e\[A 'history --merge ; up-or-search'

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
      {
        name = "nix-fish";
        src = pkgs.stra.fishplugins-nix-fish.src;
      }
    ];
  };
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      filter_mode_shell_up_key_binding = "directory";
      inline_height = 20;
      invert = true;
    };
  };
  programs.direnv = {
    enable = true;
    # enableFishIntegration = true; # default enable
    nix-direnv.enable = true;
  };
}
