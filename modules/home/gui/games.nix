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
      r2modman
      mangohud
      gamemode
    ];
  };
}
