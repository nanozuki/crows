{ clips, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.apps.git;
in
{
  options.apps.git = { enable = mkEnableOption "git"; };
  config = mkIf cfg.enable {
    home.packages = clips.darwinOr [ pkgs.git ] [ ];
    programs.git = {
      enable = true;
      package = clips.darwinOr pkgs.emptyDirectory pkgs.git;
      aliases = {
        st = "status";
        df = "difftool";
        ci = "commit -S";
        co = "checkout";
        rb = "rebase -i";
        aa = "add .";
        tg = "tag -s";
        tree = "log --all --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr, %ad) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short";
      };
      extraConfig = {
        core = {
          editor = "nvim";
        };
        user = {
          name = "Nanozuki Crows";
          email = "nanozuki.crows@gmail.com";
        };
        sendemail = {
          smtpserver = "smtp.gmail.com";
          smtpuser = "nanozuki.crows@gmail.com";
          smtpencryption = "tls";
          smtpserverport = "587";
        };
        diff = {
          tool = "nvimdiff";
        };
        include = {
          path = "${config.xdg.configHome}/git/config_local";
        };
        "filter \"lfs\"" = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
        };
      };
    };
  };
}
