{ config, pkgs, ... }:
{
  xdg.enable = true;
  home.packages = with pkgs; [
    babelfish
    git
    tealdeer
    zstd
    chezmoi
    eza
    starship
    btop
    tokei
    bat
    fd
  ];
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  programs.fish = {
    enable = true;
    shellAliases = {
      psg = "ps aux | grep";
      wget = "curl -O";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      e = "eza --icons";
      el = "eza -l --icons";
      ea = "eza -a --icons";
      eal = "eza -al --icons";
      et = "eza -T --icons";
    };
    interactiveShellInit = ''
      # gpg and gpg-agent
      set -x GPG_TTY (tty)
      gpg-connect-agent updatestartuptty /bye >/dev/null
      set -x SSH_AUTH_SOCK $GNUPGHOME/S.gpg-agent.ssh

      # kubectl
      set -x KUBECONFIG "$HOME/.config/cluster/config"

      # history across fishes
      function save_history --on-event fish_preexec
          history --save
          history --merge
      end
      alias hr 'history --merge' # read and merge history from disk
      bind \e\[A 'history --merge ; up-or-search'

      # starship
      set -x STARSHIP_CONFIG ~/.config/starship/config.toml
      starship init fish | source
    '';
  };
}
