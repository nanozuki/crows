# check this url for help: https://www.userchrome.org/
{ config, lib, ... }:
with lib;
let
  cfg = config.crows.firefoxChrome;
in
{
  options.crows.firefoxChrome = {
    profilePath = mkOption {
      type = types.path;
      default = null;
      description = "Path to the Firefox profile";
    };
  };
  config = mkIf (cfg.profilePath != null) {
    home.file.firefoxSideberryUserChrome = {
      enable = true;
      source = ../../configs/firefox-chrome/userChrome.css;
      target = "${cfg.profilePath}/chrome/userChrome.css";
    };
  };
}
