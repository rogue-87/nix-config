{ ... }:
{
  services.openssh.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  services.libinput.enable = true;

  services.xserver.enable = false;
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  /*
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  */
  services.printing.enable = true;

}
