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
    pi = mkEnableOption "Pi agent";
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
    (mkIf cfg.pi {
      home.packages = with pkgs; [ pi-coding-agent ];
      home.sessionVariables = {
        PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi/agent";
      };
      home.file.pi_config = {
        enable = true;
        source = ../../configs/agents/AGENTS.md;
        target = "${config.xdg.configHome}/pi/agent/AGENTS.md";
      };
      home.file.pi_keybindings = {
        enable = true;
        source = ../../configs/agents/pi_keybindings.json;
        target = "${config.xdg.configHome}/pi/agent/keybindings.json";
      };
    })
  ];
}
