{ lib, config, pkgs, system, ... }: {
  home.packages =
    if lib.hasSuffix "darwin" system then
      [ pkgs.pinentry_mac ] else [ ];
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
  home.file.gpg_fish = {
    enable = true;
    text = ''
      # gpg and gpg-agent
      set -gx GPG_TTY (tty)
      gpg-connect-agent updatestartuptty /bye >/dev/null
      set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    '';
    target = "${config.xdg.configHome}/fish/after/gpg.fish";
  };
}
