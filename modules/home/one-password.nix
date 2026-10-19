{
  clips,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.one_password;
  sock = clips.darwinOr "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  options.crows.one_password = {
    enable = mkEnableOption "1Password";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      # SSH config needs quotes around paths with spaces; environment values do not.
      settings."*".IdentityAgent = ''"${sock}"'';
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
