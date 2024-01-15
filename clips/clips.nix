# snippets and functions
{ id, pkgs, system }:
{
  common = import ./common.nix;
  darwinOr = import ./darwinOr.nix system;
  mustache = import ./mustache.nix pkgs;
  sops-setup = import ./sops-setup.nix id;
}
