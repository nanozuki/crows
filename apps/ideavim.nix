{ config, ... }: {
  home.file.ideavim = {
    enable = true;
    source = ../configs/ideavim/ideavimrc;
    target = "${config.xdg.configHome}/ideavim/ideavimrc";
  };
}
