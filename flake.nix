{
  description = "Configurations for NixOS and Darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs }: {
    darwinConfigurations."pica" = nix-darwin.lib.darwinSystem {
      modules = [ ./machines/pica.nix ];
      specialArgs = { inherit self; };
    };
    nixosConfigurations."nest" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./machines/nest/configuration.nix ];
    };
  };
}
