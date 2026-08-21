{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrValues
    filterAttrs
    flatten
    mapAttrs
    mapAttrs'
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    nameValuePair
    types
    ;

  cfg = config.crows.agents;
  builtInSkills = ../../configs/agents/skills;

  integrations = {
    claude = {
      package = pkgs.claude-code;
      environment = {
        CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
      };
      files.claude_config = {
        source = ../../configs/agents/AGENTS.md;
        target = "${config.xdg.configHome}/claude/CLAUDE.md";
      };
      skillDirectory = "${config.xdg.configHome}/claude/skills";
    };
    codex = {
      package = pkgs.codex;
      environment = {
        CODEX_HOME = "${config.xdg.configHome}/codex";
      };
      files.codex_config = {
        source = ../../configs/agents/AGENTS.md;
        target = "${config.xdg.configHome}/codex/AGENTS.md";
      };
      skillDirectory = "${config.xdg.configHome}/codex/skills";
    };
    pi = {
      package = pkgs.pi-coding-agent;
      environment = {
        PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi/agent";
      };
      files = {
        pi_config = {
          source = ../../configs/agents/AGENTS.md;
          target = "${config.xdg.configHome}/pi/agent/AGENTS.md";
        };
        pi_keybindings = {
          source = ../../configs/agents/pi_keybindings.json;
          target = "${config.xdg.configHome}/pi/agent/keybindings.json";
        };
      };
      skillDirectory = "${config.xdg.configHome}/pi/agent/skills";
    };
  };

  skillSources = cfg.skillSources;
  enabledIntegrations = filterAttrs (name: _: cfg.${name}) integrations;
  hasEnabledIntegration = enabledIntegrations != { };

  resolvedSkills = mapAttrs (
    skillName: sourceName:
    let
      sourceExists = builtins.hasAttr sourceName skillSources;
      sourceRoot = if sourceExists then skillSources.${sourceName} else null;
    in
    {
      inherit sourceExists sourceName;
      source = if sourceExists then "${sourceRoot}/${skillName}" else null;
    }
  ) cfg.skills;

  skillAssertions = flatten (
    mapAttrsToList (
      skillName: skill:
      let
        isDirectory =
          skill.sourceExists
          && builtins.pathExists skill.source
          && builtins.readFileType skill.source == "directory";
      in
      [
        {
          assertion = skill.sourceExists;
          message = "crows.agents skill '${skillName}' references unknown source '${skill.sourceName}'.";
        }
        {
          assertion = !skill.sourceExists || isDirectory;
          message = "crows.agents skill '${skillName}' from source '${skill.sourceName}' does not resolve to a directory.";
        }
      ]
    ) resolvedSkills
  );

  integrationFiles = lib.foldlAttrs (
    files: _: integration:
    files // integration.files
  ) { } enabledIntegrations;

  skillFiles = lib.foldlAttrs (
    files: integrationName: integration:
    files
    // mapAttrs' (
      skillName: skill:
      nameValuePair "${integrationName}_skill_${skillName}" {
        enable = true;
        source = skill.source;
        target = "${integration.skillDirectory}/${skillName}";
      }
    ) resolvedSkills
  ) { } enabledIntegrations;
in
{
  options.crows.agents = {
    claude = mkEnableOption "Claude agent integration";
    codex = mkEnableOption "Codex agent integration";
    pi = mkEnableOption "Pi agent integration";

    skillSources = mkOption {
      type = types.attrsOf types.path;
      default = { };
      description = "Skill repository roots keyed by source name.";
    };

    skills = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Selected skills keyed by skill name, with source names as values.";
    };
  };

  config = lib.mkMerge [
    {
      crows.agents.skillSources.crows = lib.mkDefault builtInSkills;
    }
    (mkIf hasEnabledIntegration {
      assertions = skillAssertions;
      home.packages = map (integration: integration.package) (attrValues enabledIntegrations);
      home.sessionVariables = lib.foldlAttrs (
        environment: _: integration:
        environment // integration.environment
      ) { } enabledIntegrations;
      home.file = integrationFiles // skillFiles;
    })
  ];
}
