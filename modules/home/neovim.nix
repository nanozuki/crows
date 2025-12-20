{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.neovim;
in
{
  options.crows.neovim = {
    enable = mkEnableOption "Neovim";
    hideCommandLine = mkEnableOption "Hide Command Line";
    useGlobalStatusline = mkEnableOption "Use global statusline";
    useGofumpt = mkOption {
      description = "Use gofumpt for Go formatting";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withPython3 = false;
      withRuby = false;
      withNodeJs = true;
    };
    programs.fish.shellAbbrs = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
    home.sessionVariables = {
      EDITOR = "nvim";
    };
    home.file.neovim = {
      enable = true;
      source = ../../configs/nvim;
      target = "${config.xdg.configHome}/nvim";
      recursive = true;
    };
    home.file.neovim_settings = {
      enable = true;
      text = builtins.toJSON {
        theme = {
          name = config.g.theme.name;
        };
        use_global_statusline = cfg.useGlobalStatusline;
        hide_command_line = cfg.hideCommandLine;
        use_gofumpt = cfg.useGofumpt;
      };
      target = "${config.xdg.configHome}/nvim/settings.json";
    };
    home.packages = with pkgs; [ tree-sitter ];

    crows.languages.dataAndMarkup.enable = true;
    crows.languages.lua.enable = true;
  };
}
