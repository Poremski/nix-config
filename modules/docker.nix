{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings.features.buildkit = true;
  };
  environment.systemPackages = [ pkgs.docker-compose ];
}
