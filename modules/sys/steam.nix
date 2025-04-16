{ lib, config, ... }:
{
  options = {
    steam.enable = lib.mkEnableOption "Installs steam";
  };
  config = lib.mkIf config.steam.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
      };
    };
  };
}
