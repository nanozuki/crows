{
  clips,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.apps.one_password;
  sock = clips.darwinOr "${config.home.homeDirectory}/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock" "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  options.apps.one_password = {
    enable = mkEnableOption "1Password";
  };
  config = mkIf cfg.enable {
    home.file.one_password_ssh = {
      enable = true;
      text = ''
        Host *
        	IdentityAgent ${sock}
      '';
      target = "${config.xdg.configHome}/ssh/1p_config";
    };
    home.sessionVariables = {
      SSH_AUTH_SOCK = sock;
    };
    programs.git.settings = clips.darwinOr { } {
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
    };
  };
}
