{
  description = "Configurations for NixOS and Darwin";

  inputs = {
    crows.url = "github:nanozuki/crows";
    nixpkgs.follows = "crows/nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "crows/nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, ... }: {
    darwinConfigurations."raven" = nix-darwin.lib.darwinSystem {
      modules = [ ./machines/raven ];
      specialArgs = { inherit self; };
    };
    darwinConfigurations."pica" = nix-darwin.lib.darwinSystem {
      modules = [ ./machines/pica ];
      specialArgs = { inherit self; };
    };
    nixosConfigurations."nest" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./machines/nest/configuration.nix ];
    };
  };
}
