{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.treefmt.withConfig {
        runtimeInputs = [ pkgs.nixfmt ];
        settings.formatter.nixfmt = {
          command = "${pkgs.lib.getExe pkgs.nixfmt}";
          includes = [ "*.nix" ];
        };
      };

      nixosConfigurations.poremski = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix
        ];
      };
    };
}
