{ config, pkgs, ... }:
{
  xdg.enable = true;
  home.packages = with pkgs; [
    babelfish
    git
    tealdeer
    zstd
    wezterm
    chezmoi
    exa
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    starship
    pinentry
    pinentry_mac
    btop
    tokei
    bat
    fd
    ffmpeg
  ] ++ [ (if (pkgs.system == "x86_64-darwin" || pkgs.system == "aarch64-darwin") then pkgs.pinentry_mac else pkgs.pinentry) ];
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
      e = "exa --icons";
      el = "exa -l --icons";
      ea = "exa -a --icons";
      eal = "exa -al --icons";
      et = "exa -T --icons";
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
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
}
