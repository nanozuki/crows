{ config, ... }: {
  home.file.git = {
    enable = true;
    source = ../configs/git;
    target = "${config.xdg.configHome}/git";
    recursive = true;
  };
}
