{ ... }:
{
  config = {
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;

    g.theme = {
      name = "zenbones";
      variant = "light";
    };

    home.sessionVariables = {
      OS_CONFIG_NAME = "treepie";
      HM_CONFIG_NAME = "treepie";
    };

    crows.ghostty.enable = true;
    crows.git.enable = true;
    crows.languages.nix.enable = true;
    crows.neovim = {
      enable = true;
      hideCommandLine = true;
      useGlobalStatusline = true;
    };
    crows.one_password.enable = true;
    crows.shell.enable = true;
  };
}
