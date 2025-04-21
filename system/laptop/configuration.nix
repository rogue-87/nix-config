{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./hardware.nix
    ./network.nix
    ./programs.nix
    ./../../modules/sys/hardware/nvidia.nix
    ./../../modules/sys
  ];

  nixpkgs.config.allowUnfree = true;
  # modules
  nvidia.enable = true;
  docker.enable = true;
  steam.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Africa/Tripoli";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AG";
    LC_IDENTIFICATION = "en_AG";
    LC_MEASUREMENT = "en_AG";
    LC_MONETARY = "en_AG";
    LC_NAME = "en_AG";
    LC_NUMERIC = "en_AG";
    LC_PAPER = "en_AG";
    LC_TELEPHONE = "en_AG";
    LC_TIME = "en_AG";
  };

  users.users.rogue = {
    isNormalUser = true;
    description = "Rogue";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  xdg.portal.enable = true;

  # WARN: read "man configuration.nix" or "https://nixos.org/nixos/options.html"  before changing
  system.stateVersion = "24.11";
}
