{
  description = "Home Manager configuration of crows";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stratosphere = {
      url = "git+https://git.sr.ht/~fubuki/stratosphere";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, home-manager, stratosphere, rust-overlay, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      spkgs = stratosphere.packages.${system};
    in
    {
      homeConfigurations."crows" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./m1mbp.home.nix
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default ];
            nixpkgs.config = {
              allowUnfree = true;
              allowUnfreePredicate = (_: true);
            };
          })
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit spkgs; inherit system; host = "m1mbp"; };
      };
    };
}
