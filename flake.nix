{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.poremski = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix
        ];
      };
    };
}
