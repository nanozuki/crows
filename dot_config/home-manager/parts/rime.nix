{ config, system, lib, ... }:
{
  home.file.rime_common = {
    enable = true;
    source = ../configs/rime;
    recursive = true;
    target = (
      if (lib.hasSuffix "darwin" system)
      then "${config.home.homeDirectory}/Library/Rime"
      else "${config.home.homeDirectory}/.local/share/fcitx5/rime"
    );
  };
}
