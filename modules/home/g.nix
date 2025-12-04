# global variables
{ lib, pkgs, ... }:
with lib;
{
  options.g.font = {
    family = mkOption {
      type = types.str;
      default = "JetBrains Mono NL";
    };
    size = mkOption {
      type = types.int;
      default = 14;
    };
  };
  # avaliable theme names: ["rose-pine" "zonbones"]
  options.g.theme = {
    name = mkOption {
      type = types.str;
      default = "rose-pine";
      description = "theme name, theme must be able to dynamic switch light/dark based on system";
    };
  };
  config = {
    home.packages = [
      pkgs.mustache-go # dependency of clips.mustache, avoid nix gc
    ];
  };
}
