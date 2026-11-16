{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/chatgpt.nix
    ./modules/docker.nix
    ./modules/fonts.nix
    ./modules/mullvad.nix
    ./modules/desktop.nix
    ./modules/home-manager.nix
    ./modules/laptop.nix
    ./modules/nix.nix
    ./modules/nix-ld.nix
    ./modules/onepassword.nix
    ./modules/packages.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    # Manual swap unlock; keep outside the generated hardware configuration.
    initrd.luks.devices."luks-90615163-2305-486f-8cc2-85cdc34c953f".device =
      "/dev/disk/by-uuid/90615163-2305-486f-8cc2-85cdc34c953f";
  };

  networking = {
    hostName = "poremski";
    domain = "home.arpa";
  };
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."javier" = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Javier Poremski";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs.fish.enable = true;

  # Compatibility baseline for persisted state; changing it does not upgrade NixOS.
  system.stateVersion = "26.05";
}
