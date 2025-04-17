{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    steam.enable = lib.mkEnableOption "Installs steam";
  };
  config = lib.mkIf config.steam.enable {
    environment.systemPackages = with pkgs; [
      steamcmd
    ];
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        # fixes the weird mouse cursor issue being very small and not using kde theme
        extraPackages = with pkgs; [
          kdePackages.breeze
        ];
      };
    };
  };
}
