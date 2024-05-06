{ config, lib, pkgs, vars, ... }:
with lib;
let
  cfg = config.apps.neovim;
in
{
  options.apps.neovim = {
    enable = mkEnableOption "Neovim";
    useNoice = mkEnableOption "Noice";
    useGlobalStatusline = mkEnableOption "Global statusline";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ripgrep fzf ];
    programs.neovim = {
      enable = true;
      withPython3 = true;
      withNodeJs = true;
      # dependencies for CopilotChat.nvim
      extraPython3Packages = (pyPkgs: with pyPkgs; [ python-dotenv requests prompt-toolkit tiktoken ]);
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
    home.file.neovim_custom = {
      enable = true;
      text = builtins.toJSON {
        theme = {
          name = vars.theme.name;
          variant = vars.theme.variant;
        };
        use_global_statusline = cfg.useGlobalStatusline;
        use_noice = cfg.useNoice;
      };
      target = "${config.xdg.configHome}/nvim/custom.json";
    };
    languages.dataAndMarkup.enable = true;
    languages.lua.enable = true;
  };
}
