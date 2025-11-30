{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.starship;
  presetsPath = "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml";
  preset = builtins.fromTOML (builtins.readFile presetsPath);
in
{
  options.crows.starship = {
    enable = mkEnableOption "starship";
  };
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = mkMerge [
        preset
        {
          character = {
            success_symbol = "[»](bold purple)";
            error_symbol = "[»](bold red)";
          };
          directory = {
            truncation_length = 10;
            truncate_to_repo = false;
            fish_style_pwd_dir_length = 1;
          };
          git_metrics = {
            added_style = "green";
            deleted_style = "red";
            format = "([+$added]($added_style))([-$deleted]($deleted_style)) ";
            disabled = false;
          };
          status = {
            disabled = false;
          };
          lua = {
            disabled = true;
          };
          aws = {
            disabled = true;
          };
          gcloud = {
            disabled = true;
          };
        }
      ];
    };
  };
}
