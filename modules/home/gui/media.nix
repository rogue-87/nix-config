{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    media.enable = lib.mkEnableOption "installs media related stuff";
  };
  config = lib.mkIf config.media.enable {
    home.packages = with pkgs; [
      youtube-music
      musikcube
      obs-studio
      gpu-screen-recorder
      gimp
      onlyoffice-desktopeditors
    ];
  };
}
