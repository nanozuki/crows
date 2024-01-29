{ clips, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.apps.gpg;
in
{
  options.apps.gpg = { enable = mkEnableOption "gpg"; };
  config = mkIf cfg.enable {
    home.packages = clips.darwinOr [ pkgs.pinentry_mac ] [ ];
    programs.gpg = {
      enable = true;
      package = clips.darwinOr pkgs.gnupg pkgs.emptyDirectory;
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
        ${clips.darwinOr "" "pinentry-program /usr/bin/pinentry-tty"}
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
