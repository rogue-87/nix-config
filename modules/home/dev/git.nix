{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    git.enable = lib.mkEnableOption "Installs and configures git";
  };
  config = lib.mkIf config.git.enable {
    home.packages = with pkgs; [
      gh
      gitoxide
    ];

    programs.git = {
      enable = true;
      userName = "Rogue";
      userEmail = "rogue87@tuta.io";
    };
  };
}
