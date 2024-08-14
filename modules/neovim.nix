{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.apps.neovim;
in
{
  options.apps.neovim = {
    enable = mkEnableOption "Neovim";
    hideCommandLine = mkEnableOption "Hide Command Line";
    useGlobalStatusline = mkEnableOption "Use global statusline";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ripgrep fzf ];
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withPython3 = false;
      withRuby = false;
      withNodeJs = true;
      # dependencies for CopilotChat.nvim
      extraLuaPackages = ps: [ ps.tiktoken_core ];
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
      source = ../configs/nvim;
      target = "${config.xdg.configHome}/nvim";
      recursive = true;
    };
    home.file.neovim_settings = {
      enable = true;
      text = builtins.toJSON {
        theme = {
          name = config.g.theme.name;
          variant = config.g.theme.variant;
        };
        use_global_statusline = cfg.useGlobalStatusline;
        hide_command_line = cfg.hideCommandLine;
      };
      target = "${config.xdg.configHome}/nvim/settings.json";
    };
    languages.dataAndMarkup.enable = true;
    languages.lua.enable = true;
  };
}
