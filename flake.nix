{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      plasma-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system}.lint = pkgs.writeShellApplication {
        name = "lint";
        runtimeInputs = with pkgs; [
          deadnix
          markdownlint-cli2
          statix
        ];
        text = ''
          statix check --ignore hardware-configuration.nix .
          deadnix --fail --exclude hardware-configuration.nix .
          markdownlint-cli2 "**/*.md" "#.git/**"
        '';
      };

      formatter.${system} = pkgs.treefmt.withConfig {
        runtimeInputs = [ pkgs.nixfmt ];
        settings.formatter.nixfmt = {
          command = "${pkgs.lib.getExe pkgs.nixfmt}";
          includes = [ "*.nix" ];
        };
      };

      nixosConfigurations.poremski = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgsUnstable; };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          { home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ]; }
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
        ];
      };
    };
}
