# global variables
{ lib, ... }:
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
  options.g.theme = {
    name = mkOption {
      type = types.str;
      default = "rose-pine";
    };
    variant = mkOption {
      type = types.str;
      default = "dawn";
    };
  };
}
