{ lib, pkgs, stpkgs, system, ... }:
{
  apps.bat.enable = true;
  apps.gpg.enable = true;
  apps.ideavim.enable = true;
  apps.kitty.enable = true;
  apps.starship.enable = true;
  apps.wezterm.enable = true;
  apps.git.enable = true;

  xdg.enable = true;
  home.packages = with pkgs; [
    babelfish
    tealdeer
    eza
    btop
    (if (lib.hasSuffix "darwin" system) then stpkgs.tokei else tokei)
    fd
    jq
    gron
    (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.cloud-firestore-emulator ]))
    openjdk
    just
    mkcert
    nssTools
    helix
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
    };
    functions = {
      gitget = { body = builtins.readFile ../configs/fish/functions/gitget.fish; };
      import_gpg_keys = { body = builtins.readFile ../configs/fish/functions/import_gpg_keys.fish; };
      update-env = { body = builtins.readFile ../configs/fish/functions/update-env.fish; };
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
  };
}
