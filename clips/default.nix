# snippets and functions
pkgs: system: {
  darwinOr = import ./darwin-or.nix system;
  mustache = import ./mustache.nix pkgs;
}
