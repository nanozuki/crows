{
  description = "Home Manager configuration of working laptop";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, stratosphere, rust-overlay, sops-nix, ... }:
    let
      system = "x86_64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      spkgs = stratosphere.packages.${system};
    in
    {
      homeConfigurations."crows" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default ];
            nixpkgs.config = {
              allowUnfree = true;
              allowUnfreePredicate = (_: true);
            };
          })
          sops-nix.homeManagerModule
          ./pica.home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit spkgs;
          inherit system;
          # variables for customizing
          vars = {
            fontSize = 14;
            fontFamily = "JetBrainsMonoNL Nerd Font";
          };
        };
      };
    };
}
