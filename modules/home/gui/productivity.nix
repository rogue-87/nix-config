{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    productivity.enable = lib.mkEnableOption "obsidian & libreoffice";
  };
  config = lib.mkIf config.productivity.enable {
    home.packages = with pkgs; [
      obsidian
      libreoffice
    ];
  };
}
