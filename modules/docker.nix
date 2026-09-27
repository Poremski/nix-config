{ lib, pkgs, ... }:
{
  users.users.javier.extraGroups = lib.mkAfter [ "docker" ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings.features.buildkit = true;
  };
  environment.systemPackages = [ pkgs.docker-compose ];
}
