{
  clips,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.git;
in
{
  options.crows.git = {
    enable = mkEnableOption "git";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = clips.darwinOr pkgs.emptyDirectory pkgs.git;
      settings = {
        alias = {
          st = "status";
          df = "difftool";
          ci = "commit -S";
          co = "checkout";
          rb = "rebase -i";
          aa = "add .";
          tg = "tag -s";
          tree = "log --all --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr, %ad) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short";
        };
        core = {
          editor = "nvim";
        };
        diff = {
          tool = "nvimdiff";
        };
        "filter \"lfs\"" = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        push = {
          autoSetupRemote = true;
        };
        sendemail = {
          smtpserver = "smtp.gmail.com";
          smtpuser = "nanozuki.crows@gmail.com";
          smtpencryption = "tls";
          smtpserverport = "587";
        };
        user = {
          name = "Nanozuki Crows";
          email = "nanozuki.crows@gmail.com";
        };
      };
      includes = [
        { path = "${config.xdg.configHome}/git/config_local"; }
      ];
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDlyirz8SBnqzKPX6kvGX6eoBtFCOK87KTmIVZC7R2N9";
        format = "ssh";
        signByDefault = true;
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
    programs.lazygit.enable = true;
  };
}
