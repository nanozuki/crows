{ home-manager, pkgs }:
let
  inherit (pkgs) lib;
  agentsModule = ../modules/home/agents.nix;
  skillsRoot = ../configs/agents/skills;

  mkHome =
    agents:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        agentsModule
        {
          home.username = "agent-test";
          home.homeDirectory = "/home/agent-test";
          home.stateVersion = "26.05";
          crows.agents = agents;
        }
      ];
    };

  integrated = mkHome {
    claude = true;
    codex = true;
    pi = true;
    skillSources.local = skillsRoot;
    skills = {
      software-design = "crows";
      handoff = "local";
    };
  };
  empty = mkHome {
    claude = true;
  };
  disabled = mkHome {
    skills.missing = "missing-source";
  };
  invalidSource = builtins.tryEval (
    builtins.deepSeq
      (mkHome {
        pi = true;
        skills.missing = "missing-source";
      }).activationPackage.drvPath
      true
  );
  invalidDirectory = builtins.tryEval (
    builtins.deepSeq
      (mkHome {
        codex = true;
        skillSources.files = ../configs/agents;
        skills."AGENTS.md" = "files";
      }).activationPackage.drvPath
      true
  );

  expectedSkillFiles = [
    "claude_skill_software-design"
    "codex_skill_software-design"
    "pi_skill_software-design"
    "claude_skill_handoff"
    "codex_skill_handoff"
    "pi_skill_handoff"
  ];
  files = integrated.config.home.file;
in
{
  module =
    assert lib.all (name: builtins.hasAttr name files) expectedSkillFiles;
    assert files.claude_skill_software-design.source == "${skillsRoot}/software-design";
    assert files.pi_skill_handoff.source == "${skillsRoot}/handoff";
    assert integrated.config.crows.agents.skillSources.crows == skillsRoot;
    assert lib.elem pkgs.claude-code integrated.config.home.packages;
    assert lib.elem pkgs.codex integrated.config.home.packages;
    assert lib.elem pkgs.pi-coding-agent integrated.config.home.packages;
    assert
      integrated.config.home.sessionVariables.CLAUDE_CONFIG_DIR == "/home/agent-test/.config/claude";
    assert integrated.config.home.sessionVariables.CODEX_HOME == "/home/agent-test/.config/codex";
    assert
      integrated.config.home.sessionVariables.PI_CODING_AGENT_DIR == "/home/agent-test/.config/pi/agent";
    assert builtins.hasAttr "claude_config" files;
    assert builtins.hasAttr "codex_config" files;
    assert builtins.hasAttr "pi_config" files;
    assert builtins.hasAttr "pi_keybindings" files;
    assert empty.config.home.file ? claude_config;
    assert !(empty.config.home.file ? claude_skill_software-design);
    assert disabled.activationPackage.drvPath != "";
    assert !invalidSource.success;
    assert !invalidDirectory.success;
    pkgs.runCommand "agents-module-check" { } "touch $out";
}
