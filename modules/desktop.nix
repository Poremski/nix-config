_:

{
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "intl";
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

  console.keyMap = "us-acentos";
  security.rtkit.enable = true;
  programs.firefox.enable = true;
}
