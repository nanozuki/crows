# snippets and functions
pkgs: system:
{
  common = import ./common.nix;
  darwinOr = import ./darwin-or.nix system;
  mustache = import ./mustache.nix pkgs;
}
