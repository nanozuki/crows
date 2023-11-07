{ config, lib, pkgs, system, vars, ... }:
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
    jq
    gron
    (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.cloud-firestore-emulator ]))
    openjdk
    just
    mkcert
    nssTools
  ];
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  programs.gpg = {
    enable = lib.hasSuffix "darwin" system;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
  home.file.gpg_agent = {
    enable = true;
    text = ''
      enable-ssh-support
      max-cache-ttl 60480000
      default-cache-ttl 60480000
      max-cache-ttl-ssh 60480000
      default-cache-ttl-ssh 60480000
      ${if lib.hasSuffix "linux" system then "pinentry-program /usr/bin/pinentry-tty" else ""}
    '';
    target = "${config.xdg.dataHome}/gnupg/gpg-agent.conf";
  };
  programs.kitty = {
    enable = true;
    package = pkgs.fish; # just to ignore package installation
    font.name = vars.fontFamily;
    font.size = vars.fontSize;
    extraConfig = builtins.readFile ../configs/kitty/kitty.conf;
    shellIntegration.enableFishIntegration = true;
    theme = "Rosé Pine Dawn";
  };
  home.file.kitty = {
    enable = true;
    source = ../configs/kitty/kitty.app.png;
    recursive = true;
    target = "${config.xdg.configHome}/kitty/kitty.app.png";
  };
  home.file.wezterm = {
    enable = true;
    source = ../configs/wezterm;
    recursive = true;
    target = "${config.xdg.configHome}/wezterm";
  };
  home.file.wezterm_vars =
    let
      mustache = import ../tools/mustache.nix;
    in
    {
      enable = true;
      source = mustache pkgs "vars.lua" ../configs/wezterm/vars.lua.mustache vars;
      target = "${config.xdg.configHome}/wezterm/vars.lua";
    };
  programs.fish = {
    enable = true;
    shellAbbrs = {
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
      set -gx GPG_TTY (tty)
      gpg-connect-agent updatestartuptty /bye >/dev/null
      set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

      # kubectl
      set -gx KUBECONFIG "$HOME/.config/cluster/config"

      # history across fishes
      function save_history --on-event fish_preexec
          history --save
          history --merge
      end
      alias hr 'history --merge' # read and merge history from disk
      bind \e\[A 'history --merge ; up-or-search'

      # starship
      set -gx STARSHIP_CONFIG ~/.config/starship/config.toml
      starship init fish | source

      # source after snippets
      for file in $HOME/.config/fish/after/*.fish
          source $file
      end
    '';
  };
}
