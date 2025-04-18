{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    social.enable = lib.mkEnableOption "discord, telegram, etc...";
  };
  config = lib.mkIf config.social.enable {
    home.packages = with pkgs; [
      discord
      telegram-desktop
      # element-desktop
    ];
  };
}
