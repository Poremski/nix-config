{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      glib
      nspr
      nss
      atk
      at-spi2-core
      dbus
      cups
      expat
      libxcb
      libxkbcommon
      alsa-lib
      libgbm
      libx11
      libxext
      libxcomposite
      libxdamage
      libxfixes
      libxrandr
      cairo
      pango
      gdk-pixbuf
      gtk3
      systemd
    ];
  };

  environment.systemPackages = [
    (pkgs.callPackage ./default.nix { })
  ];
}
