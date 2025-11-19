{
  clips,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.apps.rime;
in
{
  options.apps.rime = {
    enable = mkEnableOption "Rime";
  };

  config = mkIf cfg.enable {
    home.file.rime_common = {
      enable = true;
      source = ../configs/rime;
      recursive = true;
      target = (
        clips.darwinOr "${config.home.homeDirectory}/Library/Rime" "${config.home.homeDirectory}/.local/share/fcitx5/rime"
      );
    };
    home.file.rime_squirrel = {
      enable = clips.darwinOr true false;
      source = ../configs/squirrel/squirrel.custom.yaml;
      recursive = true;
      target = "${config.home.homeDirectory}/Library/Rime/squirrel.custom.yaml";
    };
  };
}
