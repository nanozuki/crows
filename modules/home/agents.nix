{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.crows.agents;
  publicSkillsDir = ../../configs/agents/skills;
  publicSkills = mapAttrs (name: _: publicSkillsDir + "/${name}") (
    filterAttrs (_: type: type == "directory") (builtins.readDir publicSkillsDir)
  );
  skills = publicSkills // cfg.skills;
  mkSkillFiles =
    prefix: targetDir:
    mapAttrs' (
      name: source:
      nameValuePair "${prefix}_${name}" {
        enable = true;
        inherit source;
        target = "${targetDir}/${name}";
      }
    ) skills;
in
{
  options.crows.agents = {
    claude = mkEnableOption "Claude agent";
    codex = mkEnableOption "Codex agent";
    pi = mkEnableOption "Pi agent";
    skills = mkOption {
      type = types.attrsOf types.path;
      default = { };
      description = "Extra agent skills keyed by skill name.";
    };
  };

  config = mkMerge [
    (mkIf cfg.claude {
      home.packages = with pkgs; [ claude-code ];
      home.sessionVariables = {
        CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
      };
      home.file = {
        claude_config = {
          enable = true;
          source = ../../configs/agents/AGENTS.md;
          target = "${config.xdg.configHome}/claude/CLAUDE.md";
        };
      } // mkSkillFiles "claude_skill" "${config.xdg.configHome}/claude/skills";
    })
    (mkIf cfg.codex {
      home.packages = with pkgs; [ codex ];
      home.sessionVariables = {
        CODEX_HOME = "${config.xdg.configHome}/codex";
      };
      home.file = {
        codex_config = {
          enable = true;
          source = ../../configs/agents/AGENTS.md;
          target = "${config.xdg.configHome}/codex/AGENTS.md";
        };
      } // mkSkillFiles "codex_skill" "${config.xdg.configHome}/codex/skills";
    })
    (mkIf cfg.pi {
      home.packages = with pkgs; [ pi-coding-agent ];
      home.sessionVariables = {
        PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi/agent";
      };
      home.file = {
        pi_config = {
          enable = true;
          source = ../../configs/agents/AGENTS.md;
          target = "${config.xdg.configHome}/pi/agent/AGENTS.md";
        };
        pi_keybindings = {
          enable = true;
          source = ../../configs/agents/pi_keybindings.json;
          target = "${config.xdg.configHome}/pi/agent/keybindings.json";
        };
      } // mkSkillFiles "pi_skill" "${config.xdg.configHome}/pi/agent/skills";
    })
  ];
}
