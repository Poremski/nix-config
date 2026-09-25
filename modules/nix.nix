{ ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Remove store paths that have not been reachable for 30 days.
  # Bootable system generations remain available until they become older
  # than this retention period.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Deduplicate identical files in the Nix store once a week.
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
}
