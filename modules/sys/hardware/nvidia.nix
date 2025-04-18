# the green devil that is nvidia
{ lib, config, ... }:
{
  options = {
    nvidia.enable = lib.mkEnableOption "Installs nvidia drivers";
  };
  config = lib.mkIf config.nvidia.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    nixpkgs.config.nvidia.acceptLicense = true;
  };

}
