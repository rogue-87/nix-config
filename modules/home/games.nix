{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    games.enable = lib.mkEnableOption "Installs game launchers and emulators";
  };
  config = lib.mkIf config.games.enable {
    home.packages = with pkgs; [
      heroic
      pcsx2
      rpcs3
      r2modman
    ];
  };
}
