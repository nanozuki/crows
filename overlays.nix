{ inputs, ... }:
let
  stablePackages = [ "tealdeer" ];
  stableOverlay =
    final: prev:
    builtins.listToAttrs (
      map (name: {
        name = name;
        value = inputs.stable-nixpkgs.legacyPackages.${prev.system}.${name};
      }) stablePackages
    );
  stratosphereOverlay = final: prev: { stra = inputs.stratosphere.packages.${prev.system}; };
in
{
  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
    stableOverlay
    stratosphereOverlay
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };
}
