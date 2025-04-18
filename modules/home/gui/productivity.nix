{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    productivity.enable = lib.mkEnableOption "installs media related stuff";
  };
  config = lib.mkIf config.productivity.enable {
    home.packages = with pkgs; [
      obsidian
      onlyoffice-desktopeditors
    ];
  };
}
