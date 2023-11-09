{ lib, config, pkgs, system, ... }:
with lib;
let cfg = config.apps.gpg;
in
{
  options.apps.gpg = { enable = mkEnableOption "gpg"; };
  config = mkIf cfg.enable {
    home.packages =
      if lib.hasSuffix "darwin" system then
        [ pkgs.pinentry_mac ] else [ ];
    programs.gpg = {
      enable = true;
      package = if (lib.hasSuffix "darwin" system) then pkgs.gnupg else pkgs.hello;
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
  };
}
