{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.agents;
in
{
  options.crows.agents = {
    claude = mkEnableOption "Claude agent";
    codex = mkEnableOption "Codex agent";
  };

  config = mkMerge [
    (mkIf cfg.claude {
      home.packages = with pkgs; [ claude-code ];
      home.sessionVariables = {
        CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
      };
      home.file.claude_config = {
        enable = true;
        source = ../../configs/agents/AGENTS.md;
        target = "${config.xdg.configHome}/claude/CLAUDE.md";
      };
    })
    (mkIf cfg.codex {
      home.packages = with pkgs; [ codex ];
      home.sessionVariables = {
        CODEX_HOME = "${config.xdg.configHome}/codex";
      };
      home.file.codex_config = {
        enable = true;
        source = ../../configs/agents/AGENTS.md;
        target = "${config.xdg.configHome}/codex/AGENTS.md";
      };
    })
  ];
}
