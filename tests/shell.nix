# Check shared tool directories and their lifetime under the shell module.
{ home-manager, pkgs }:
let
  inherit (pkgs) lib;
  mkHome =
    enable:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs.system = pkgs.stdenv.hostPlatform.system;
      modules = [
        ../modules/home/shell.nix
        {
          home.username = "shell-test";
          home.homeDirectory = "/home/shell-test";
          home.stateVersion = "26.05";
          crows.shell.enable = enable;
        }
      ];
    };
  enabled = mkHome true;
  disabled = mkHome false;
  inherit (enabled.config) xdg;
  env = enabled.config.home.sessionVariables;
  packageNames = map lib.getName enabled.config.home.packages;
  projectTools = [
    "go"
    "gopls"
    "rustc"
    "cargo"
    "rust-analyzer"
    "lua-language-server"
    "stylua"
    "nil"
    "nixfmt"
    "vscode-langservers-extracted"
    "yaml-language-server"
    "prettier"
  ];
in
{
  shellDirectories =
    assert env.GOPATH == "${xdg.dataHome}/go";
    assert env.CARGO_HOME == "${xdg.dataHome}/cargo";
    assert env.NPM_CONFIG_USERCONFIG == "${xdg.configHome}/npm/npmrc";
    assert !(env ? GOROOT);
    assert !(env ? GOBIN);
    assert enabled.config.home.sessionPath == [ "$HOME/.local/bin" ];
    assert lib.all (name: !(lib.elem name packageNames)) projectTools;
    assert !enabled.config.programs.go.enable;
    assert !(enabled.options ? crows.languages);
    assert
      enabled.config.home.file.npmrc.target
      == lib.removePrefix "${enabled.config.home.homeDirectory}/" "${xdg.configHome}/npm/npmrc";
    assert lib.hasInfix "prefix=${xdg.dataHome}/npm" enabled.config.home.file.npmrc.text;
    assert lib.hasInfix "cache=${xdg.cacheHome}/npm" enabled.config.home.file.npmrc.text;
    assert lib.hasInfix "init-module=${xdg.configHome}/npm/config/npm-init.js"
      enabled.config.home.file.npmrc.text;
    assert !(disabled.config.home.sessionVariables ? GOPATH);
    assert !(disabled.config.home.sessionVariables ? CARGO_HOME);
    assert !(disabled.config.home.sessionVariables ? NPM_CONFIG_USERCONFIG);
    assert !(disabled.config.home.file ? npmrc);
    pkgs.runCommand "shell-directories-check" { } "touch $out";
}
