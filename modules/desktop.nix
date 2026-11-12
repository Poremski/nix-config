_:

{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "colemak_dh_iso";
      };
    };

    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    printing.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  console = {
    earlySetup = true;
    useXkbConfig = true;
  };
  security.rtkit.enable = true;
  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;
}
